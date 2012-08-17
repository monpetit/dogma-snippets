%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-

-module(processes).
-export([main/0, main/1, max/1]).

newline() ->
    io:format("~n").

prt(O) ->
    io:format("~p~n", [O]).

prt_str(Str) ->
    io:format(Str ++ "~n").

for(N, N, F) -> [F()];
for(I, N, F) -> [F() | for(I+1, N, F)].

wait() ->
    receive
	die -> void
    end.

max(N) ->
    Max = erlang:system_info(process_limit),
    io:format("Maximum allowed processes: ~p~n", [Max]),
    statistics(runtime),
    statistics(wall_clock),
    L = for(1, N, fun() -> spawn(fun wait/0) end),
    {_, Time1} = statistics(runtime),
    {_, Time2} = statistics(wall_clock),
    lists:foreach(fun(Pid) -> Pid ! die end, L),
    U1 = Time1 * 1000 / N,
    U2 = Time2 * 1000 / N,
    io:format("Process spawn time = ~p (~p) microseconds~n",
	      [U1, U2]).


main() ->
    main(1000).

main(N) ->
    max(N).

% vim: set ft=erlang et:
