%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-

-module(stimer).
-compile(export_all).

start(Time, Fun) ->
%%    spawn(fun() -> timer(Time, Fun) end).
    spawn(?MODULE, timer, [Time, Fun]).

cancel(Pid) -> Pid ! cancel.

timer(Time, Fun) ->
    receive
	cancel -> void
    after Time ->
	    Fun()
    end.
