-module(timer_demo).

-compile(export_all).

on_loop_timer(Args) ->
  io:format("on_loop_timer ~p~n", [Args]).

on_single_timer(Args) ->
  io:format("on_single_timer ~p~n", [Args]).

demo() ->
  gen_timer:start_loop_timer(2000, ?MODULE, on_loop_timer, ["111", "222"]),
  gen_timer:start_single_timer(5000, ?MODULE, on_single_timer, ["333", "444"]).