-module(gen_timer).

-behaviour(gen_server).
-record(timer_record, {timer_ref, duration, args, mod, callback}).

-export([start_link/4, start/4, stop/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link(Duration, Args, Mod, CallBack) ->
  gen_server:start_link(?MODULE, [Duration, Args, Mod, CallBack], []).

%用于单独启动
start(Duration, Args, Mod, CallBack) ->
  gen_server:start_link(?MODULE, [Duration, Args, Mod, CallBack], []).

stop(Pid) ->
  gen_server:cast(Pid, stop),
  ok.

init([Duration, Args, Mod, CallBack]) ->
  process_flag(trap_exit, true),

  TimeInterval = round(Duration),
  {ok, TimerRef} = timer:send_interval(TimeInterval * 1000, self(), timer_msg),
  TimerRecord = #timer_record{timer_ref = TimerRef, duration = TimeInterval, args = Args, mod = Mod, callback = CallBack},
  {ok, TimerRecord, 0}.

%% callbacks
handle_call(Msg, _From, State) ->
  {reply, {ok, Msg}, State}.

handle_cast(stop, State) ->
  {stop, normal, State};

handle_cast(_Request, State) ->
  {noreply, normal, State}.

handle_info({'EXIT', Pid, Reason}, State) ->
  io:format("exit reason ~p~n", [Reason]),
  case Reason of
    normal ->
      io:format("normal exit trapped~n"),
      {stop, normal, State};
    other ->
      io:format("other exit trapped~n"),
      {noreply, State}
  end;

handle_info(timer_msg, #timer_record{timer_ref = TimerRef, duration = TimeInterval, args = Args, mod = Mod, callback = CallBack} = TimerRecord) ->
%%     io:format("timer msg is ~p~n",[TimerRecord]),
  Mod:CallBack(Args),
  {noreply, TimerRecord};

handle_info(Info, StateData) ->
%%     io:format("Info ~p, StateData ~p~n",[Info,StateData]),
  {noreply, StateData}.

terminate(_Reason, #timer_record{timer_ref = TimerRef, duration = TimeInterval, args = Args, mod = Mod, callback = CallBack} = TimerRecord) ->
  timer:cancel(TimerRef),
  io:format("process terminated ~p,~p~n", [_Reason, TimerRecord]),
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.