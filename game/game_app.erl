%% Feel free to use, reuse and abuse the code in this file.

%% @private
-module({{projectid}}_app).
%%-include_lib("lager/include/lager.hrl").
-behaviour(application).

%% API.
-export([start/2]).
-export([stop/1]).
%% default listen port
-define(DEFAULT_PORT, 1156).
%% default listen number
-define(DEFAULT_LISTENNUM,10).
%% flash securty port 843
-define(FAHSNPORT, 8843).
%%websocket port
-define(WEBPORT,8080).
%% default websocket listen number
-define(WEB_LISTENNUM,10).
%% wait for res
-define(WAIT_FOR_RESOURCES, 500).

%% API.
 
start(_Type, _Args) ->
	Port = case application:get_env({{projectid}}, gameport) of
               {ok, P} -> P;
               undefined -> ?DEFAULT_PORT
         end,
  ListenNum = case application:get_env({{projectid}}, listen) of
               {ok, NUM} ->NUM;
               undefined -> ?DEFAULT_LISTENNUM
           end,  
  FlashPort =  case application:get_env({{projectid}},flashport) of  
                {ok,PORT}->PORT;
                undefined -> ?FAHSNPORT
                end,    
  WebPort =  case application:get_env({{projectid}},webport) of  
                {ok,Wp}->Wp;
                undefined -> ?WEBPORT
                end,  
  WebListenNum =  case application:get_env({{projectid}},weblisten) of  
                {ok,WPN}->WPN;
                undefined -> ?WEB_LISTENNUM
                end,     
    addresource(), 
    {{projectid}}_store:init(),                                               
    case {{projectid}}_sup:start_link([Port,ListenNum,FlashPort,WebPort,WebListenNum]) of
        {ok, Pid} ->
            {ok, Pid};
        Other ->
            {error, Other}
    end.
stop(_State) ->
	ok.

addresource()->
    resource_discovery:add_local_resource_tuple({ {{projectid}} ,node()}),
    resource_discovery:add_target_resource_type({{projectid}}),
    resource_discovery:trade_resources(),
    timer:sleep(?WAIT_FOR_RESOURCES).