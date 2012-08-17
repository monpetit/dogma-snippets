%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-

-module(echo).
-compile(export_all).

go() ->
    register(echo, spawn(?MODULE, loop, [])),
    echo ! {self(), hello},
    receive
	{_Pid, Msg} ->
	    io:format("P1 ~w~n", [Msg])
    end.

loop() ->
    receive
	{From, Msg} ->
	    io:format("받은 메시지: ~w~n", [Msg]),
	    From ! {self(), Msg},
	    loop();
	stop ->
	    io:format("I'm echo server!~n"),
	    io:format("I received STOP command!~n"),
	    ok;
	_ ->
	    false,
	    loop()
    end.

main(_) ->
    go().


% vim: set ft=erlang et:
