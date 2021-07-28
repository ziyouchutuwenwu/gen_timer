-module(timer_tests).

-compile(export_all).

on_timer_callback(Args) ->
  io:format("on_timer_callback ~p~n", [Args]).

do_timer_start() ->
  gen_timer_sup:start_link(2, 100.0, ?MODULE, on_timer_callback),
  gen_timer_sup:start_child().

do_timer_stop(Pid) ->
  gen_timer_sup:stop_child(Pid).