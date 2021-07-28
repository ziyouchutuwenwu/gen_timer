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
  MaxRestarts = 2,
  MaxSecondsBetweenRestarts = 5,

  SupervisorFlags = #{
    strategy => simple_one_for_one,
    intensity => MaxRestarts,
    period => MaxSecondsBetweenRestarts
  },

  ChildSpec = #{
    id => gen_timer,
    start => {gen_timer, start_link, [Duration, Args, Mod, CallBack]},
    restart => permanent,
    shutdown => 2000,
    type => worker,
    modules => [gen_timer]
  },

  Children = [ChildSpec],
  {ok, {SupervisorFlags, Children}}.