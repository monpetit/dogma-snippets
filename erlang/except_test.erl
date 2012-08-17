%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-

-module(except_test).
-compile(export_all).

test(N) ->
    X = N,
    try (X = 3) of
	Val -> {normal, Val}
    catch
	_:_ -> 43
    end.

test2(N) ->
    X = N,
    try (X = 3) of
	Val -> {normal, Val}
    catch
	error:Error -> {error, Error}
    end.
