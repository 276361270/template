-module({{projectid}}_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/", cowboy_static, {priv_file, {{projectid}}, "index.html"}},
			{"/{{projectid}}", {{projectid}}_hander, []},
			{"/static/[...]", cowboy_static, {priv_dir,  {{projectid}}, "static"}}
		]}
	]),
	{ok, _} = cowboy:start_http(http, 100, [{port, 8080}],
		[{env, [{dispatch, Dispatch}]}]),
    {{projectid}}_sup:start_link().

stop(_State) ->
    ok.
