%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-

-module(listutils).
-compile(export_all).

reverse_create(0) -> [];
reverse_create(N) -> [N | reverse_create(N-1)].

create(N) ->
    lists:reverse(reverse_create(N)).

%% rag(0) -> [];
%% rag(N) -> [N - 1 | rag(N - 1)].

range(N) ->
    Range = fun(0, _) -> [];
	       (X, F) -> [X-1 | F(X-1, F)] end,
    lists:reverse(Range(N, Range)).

test(X) ->
    Fac  = fun(0, _) -> 1;
              (N, F) -> N * F(N-1, F) end,
    Fac(X, Fac).








% vim: set ft=erlang et:
