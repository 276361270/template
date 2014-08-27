%%%-------------------------------------------------------------------
%%% @author thinkpad <>
%%% @copyright (C) 2014, thinkpad
%%% @doc
%%%
%%% @end
%%% Created :  3 Jul 2014 by thinkpad <>
%%%-------------------------------------------------------------------
-module({{projectid}}).

%% API
-export([start/0,stop/0]).

%%%===================================================================
%%% API
%%%===================================================================
%--------------------------------------------------------------------
%% @doc start application 
%% @spec start()->ok.
%% @end
%%--------------------------------------------------------------------

start()->    
    ensure_started({{projectid}}),
    case reloader:start() of
	{ok,_App} ->
           ok;
	{error,{already_started,_App}} ->
	    ok 
	end.
 
%--------------------------------------------------------------------
%% @doc stop application
%% @spec stop()->ok.
%% @end
%%--------------------------------------------------------------------

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