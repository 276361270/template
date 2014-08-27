%%%-------------------------------------------------------------------
%%% @author thinkpad <>
%%% @copyright (C) 2014, thinkpad
%%% @doc
%%%
%%% @end
%%% Created : 27 Jun 2014 by thinkpad <>
%%%-------------------------------------------------------------------
-module({{projectid}}_store).

-include_lib("stdlib/include/qlc.hrl" ).
%% API
-export([init/0,insert/2,delete/1,lookup/1,lookall/0]).

-record(socket_to_pid, {socket,pid}).

-define(WAIT_FOR_TABLES, 10000).

%%%===================================================================
%%% API
%%%===================================================================
init()->
    CacheNode=resource_discovery:get_resources(game),
    dynamic_db_init(lists:delete(node(),CacheNode)).
    
 %--------------------------------------------------------------------
%% @doc Insert a key and pid.
%% @spec insert(Key, Pid) -> void()
%% @end
%%--------------------------------------------------------------------
insert(Pid,Socket) when is_pid(Pid) ->
    io:format("~p~p",[Pid,Socket]),
    Fun = fun() -> mnesia:write(#socket_to_pid{pid = Pid, socket = Socket}) end,
    {atomic, _} = mnesia:transaction(Fun).

%%--------------------------------------------------------------------
%% @doc Find a pid given a key.
%% @spec lookup(Key) -> {ok, Pid} | {error, not_found}
%% @end
%%--------------------------------------------------------------------
lookup(Pid) ->
   	do(qlc:q([{X#socket_to_pid.pid,X#socket_to_pid.socket} || X <- mnesia:table(socket_to_pid),X#socket_to_pid.pid==Pid])).

lookall() ->
     	do(qlc:q([{X#socket_to_pid.pid,X#socket_to_pid.socket} || X <- mnesia:table(socket_to_pid)])).

%%--------------------------------------------------------------------
%% @doc Delete an element by pid from the registrar.
%% @spec delete(Pid) -> void()
%% @end
%%--------------------------------------------------------------------
delete(Pid) ->
    try
        [#socket_to_pid{} = Record] = mnesia:dirty_index_read(socket_to_pid, Pid, #socket_to_pid.pid),
        mnesia:dirty_delete_object(Record)
    catch
        _C:_E -> ok
    end.
   

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

%%%===================================================================
%%% Internal functions
%%%===================================================================
dynamic_db_init([]) ->
    delete_schema(),
    io:format("dynamic_db_ini======================================"),
   {atomic, ok} = mnesia:create_table(socket_to_pid, [{index, [pid]}, {attributes, record_info(fields, socket_to_pid)}]),
    io:format("~p~n",[ok]);
dynamic_db_init(CacheNodes) ->
    delete_schema(),
    add_extra_nodes(CacheNodes).

%% deletes a local schema.
delete_schema() ->
    mnesia:stop(),
    mnesia:delete_schema([node()]),
    mnesia:start().

add_extra_nodes([Node|T]) ->
     io:format("remote_init add_table copy = ~p~n", [Node]),
    case mnesia:change_config(extra_db_nodes, [Node]) of
        {ok, [Node]} ->
            Res1 = mnesia:add_table_copy(socket_to_pid, node(), ram_copies),
            io:format("remote_init add_table copy = ~p~n", [Res1]),	    
            Tables = mnesia:system_info(tables),
            mnesia:wait_for_tables(Tables, ?WAIT_FOR_TABLES);
        _ ->
            add_extra_nodes(T)
    end.

do(Query) ->
	F = fun() -> qlc:e(Query) end,
	{atomic, Value} = mnesia:transaction(F),
	Value.
