-module(gen_timer).

-export([start_loop_timer/4, start_single_timer/4, init/5]).
-export([timer_loop/4, timer_wait/3]).

start_loop_timer(Druation, Mod, Fun, Args) ->
  Pid = spawn_link(?MODULE, init, [true, Druation, Mod, Fun, Args]),
  {ok, Pid}.

start_single_timer(Druation, Mod, Fun, Args) ->
  spawn_link(?MODULE, init, [false, Druation, Mod, Fun, Args]).

init(ShouldLoop, Druation, Mod, Fun, Args)->
  erlang:start_timer(Druation, self(), {on_timer}),
  case ShouldLoop of
    true ->
      timer_loop(Druation, Mod, Fun, Args);
    _ ->
      timer_wait(Mod, Fun, Args)
  end.

timer_loop(Druation, Mod, Fun, Args) ->
  receive
    {timeout, TimerRef, {on_timer}}->
      erlang:cancel_timer(TimerRef),
      erlang:start_timer(Druation, self(), {on_timer}),
      erlang:apply(Mod, Fun, [Args]),
      timer_loop(Druation, Mod, Fun, Args);
    Other ->
      io:format("will break loop, got other msg~p~n",[Other])
  end.

timer_wait(Mod, Fun, Args) ->
  receive
    {timeout, TimerRef, {on_timer}}->
      erlang:cancel_timer(TimerRef),
      erlang:apply(Mod, Fun, [Args]);
    Other ->
      io:format("will break loop, got other msg~p~n",[Other])
  end.