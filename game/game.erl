%%%-------------------------------------------------------------------
%%% @author thinkpad <>
%%% @copyright (C) 2014, thinkpad
%%% @doc
%%%
%%% @end
%%% Created : 27 Jun 2014 by thinkpad <>
%%%-------------------------------------------------------------------
-module({{projectid}}).

%% API
-export([start/0,stop/0]).

%%%===================================================================
%%% API
%%%===================================================================
start()->
    ensure_started(sasl),
    ensure_started(crypto),
    ensure_started(mnesia),  
    ensure_started(syntax_tools),
    ensure_started(compiler),
    ensure_started(goldrush), 
    ensure_started(lager),   
    ensure_started(luerl),
    ensure_started(ibrowse), 
    ensure_started(cowlib),
    ensure_started(cowboy),
    ensure_started(resource_discovery),
    ensure_started(msgpack),
    ensure_started(boss_db),
    ensure_started({{projectid}}).
 
stop()->
    application:stop({{projectid}}).
    
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------

%%%===================================================================
%%% Internal functions
%%%===================================================================
ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok
    end.
