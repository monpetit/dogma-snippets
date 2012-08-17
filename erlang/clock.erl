%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-

-module(clock).
-compile(export_all).

start(Time, Fun) ->
    register(clock, spawn(?MODULE, tick, [Time, Fun])).

stop() ->
    clock ! stop.

tick(Time, Fun) ->
    receive
	stop ->
	    void
    after Time ->
	    Fun(),
	    tick(Time, Fun)
    end.

