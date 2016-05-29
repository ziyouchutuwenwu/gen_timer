-module(gen_timer_sup).

-behaviour(supervisor).
-export([start_link/4, start_child/0, stop_child/1]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

start_link(Duration, Args, Mod, CallBack) ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, [Duration, Args, Mod, CallBack]).

start_child() ->
  supervisor:start_child(?SERVER, []).

stop_child(Pid) ->
  supervisor:terminate_child(?SERVER, Pid).

init([Duration, Args, Mod, CallBack]) ->
  RestartStrategy = simple_one_for_one,
  MaxRestarts = 1000,
  MaxSecondsBetweenRestarts = 3600,

  SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

  Restart = permanent,
  Shutdown = 2000,
  Type = worker,

  Child = {gen_timer, {gen_timer, start_link, [Duration, Args, Mod, CallBack]},
    Restart, Shutdown, Type, [gen_timer]},
  Children = [Child],
  {ok, {SupFlags, Children}}.