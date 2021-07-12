-module(on_app_start).

main(_Args) ->
  io:format("~n"),
  interprete_modules().

interprete_modules() ->
  int:ni(sync),
  int:ni(sync_scanner),
  int:ni(sync_notify),
  int:ni(sync_options),
  int:ni(sync_utils),
  int:ni(fs_app),
  int:ni(inotifywait_win32),
  int:ni(kqueue),
  int:ni(fs_server),
  int:ni(fs_event_bridge),
  int:ni(fsevents),
  int:ni(fs_sup),
  int:ni(inotifywait),
  int:ni(fs),
  int:ni(timer_tests),
  int:ni(gen_timer_sup),
  int:ni(gen_timer),

  io:format("输入 int:interpreted(). 或者 il(). 查看模块列表~n").