%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-

-module(mathstuff).
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


factorial(0) -> 1;
factorial(N) when N > 0 -> N * factorial(N-1);
factorial(N) -> {error, "invalid argument", N}.

area({square, Side}) ->
    Side * Side;
area({circle, Radius}) ->
    3.141592 * Radius * Radius;
area({triangle, A, B, C}) ->
    S = (A + B + C) / 2,
    math:sqrt(S * (S-A) * (S-B) * (S-C));
area(Other) ->
    {invalid_object, Other}.

test(X) when is_integer(X) ->
    {integer, X};
test(X) -> {unknown, X}.


average(X) ->
    average(X, 0, 0).

average([H|T], Length, Sum) ->
    average(T, Length + 1, Sum + H);
average([], Length, Sum) ->
    Sum / Length.



% vim: set ft=erlang et:
