%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-

-module(ms).
-export([main/0, main/1]).
-compile(export_all).

newline() ->
    io:format("~n").

prt(O) ->
    io:format("~p~n", [O]).

prt_str(Str) ->
    io:format(Str ++ "~n").

main() ->
    main(none).

main(_) ->
    greeting("안녕 블라디미르", 10).

%% greeting(_, Count) when Count == 0 -> ok;
greeting(_, 0) -> ok;
greeting(Str, Count) ->
    case is_list(Str) of
	true -> prt_str(Str);
	false -> prt(Str)
    end,
    greeting(Str, Count - 1).

% vim: set ft=erlang et:
