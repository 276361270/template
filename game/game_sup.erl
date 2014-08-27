%% Feel free to use, reuse and abuse the code in this file.

%% @private
-module({{projectid}}_sup).
-behaviour(supervisor).

%% API.
-export([start_link/1]).

%% supervisor.
-export([init/1]).

-define(CHILD(I, Type,Parms), {I, {I, start_link,Parms}, permanent, 5000, Type, [I]}).

%% API.
start_link([Port,ListenNum,FlashPort,WebPort,WebListenNum]) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, [Port,ListenNum,FlashPort,WebPort,WebListenNum]).

%% supervisor.

init([Port,ListenNum,FlashPort,WebPort,WebListenNum]) ->	
	 RanchSpec=?CHILD(ranch_sup,supervisor,[]),
	 WebSocket=?CHILD({{projectid}}_wsocket_sup,supervisor,[[WebPort,WebListenNum]]),
	 GameSpec =?CHILD({{projectid}}_tcp_sup,supervisor,[[Port,ListenNum]]),
	 GameFlashSpec=?CHILD({{projectid}}_tcp_flash_sup,supervisor,[[FlashPort,ListenNum]]),
	 Childs=[RanchSpec,GameFlashSpec,GameSpec,WebSocket],
    {ok, { {one_for_one, 10, 10}, Childs} }.