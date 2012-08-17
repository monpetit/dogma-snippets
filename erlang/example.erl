%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-

-module(example).
-export([start/0, start/1]).
-compile(export_all).

newline() ->
    io:format("~n").

prt(O) ->
    io:format("~p~n", [O]).

prt_str(Str) ->
    io:format(Str ++ "~n").


start() ->
    start(none).

start(_) ->
    greeting("안녕 블라디미르", 10).

greeting(Str, Count) when Count == 0 -> ok;
greeting(Str, Count) ->
    prt_str(Str),
    greeting(Str, Count - 1).
