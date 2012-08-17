%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-

-module(myring).
-compile(export_all).

start(Num) ->
    start_proc(Num, self()).

start_proc(0, Pid) ->
    io:format("end~n"),
    Pid ! ok;
start_proc(Num, Pid) ->
    NPid = spawn(?MODULE, start_proc, [Num - 1, Pid]),
    NPid ! ok,
    receive
	ok -> ok
    end.
