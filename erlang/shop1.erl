%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-

-module(shop1).
-export([total/1, start/0]).
-compile(export_all).

newline() ->
    io:format("~n").

prt(O) ->
    io:format("~p~n", [O]).

prt_str(Str) ->
    io:format(Str ++ "~n").



total([{What,N}|T]) -> shop:cost(What) * N + total(T);
total([]) -> 0.

start() ->
    Buy = [{oranges, 4},
	   {newspaper, 1},
	   {apples, 10},
	   {pears, 6},
	   {milk, 3}],
    total(Buy).

double(X) ->
    Double = fun(Y) -> 2 * Y end,
    Double(X).

double2(X) ->
    2 * X.


start_fun() ->
    Fruit = [apple, pear, grape, orange, melon],
    MakeTest = fun(L) -> (fun(X) -> lists:member(X, L) end)
	       end,
    IsFruit = MakeTest(Fruit),
    prt(IsFruit(pear)),
    prt(IsFruit(apple)),
    prt(IsFruit(dog)),
    prt(lists:filter(IsFruit, [dog, orange, cat, apple, bear])).
