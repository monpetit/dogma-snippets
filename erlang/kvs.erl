%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-

-module(kvs).
-export([start/0, store/2, lookup/1, items/0, stop/0, keys/0]).
%% -compile(export_all).

start() ->
    register(kvs, spawn(fun loop/0)).

rpc(Request) ->
    kvs ! {self(), Request},
    receive
	{kvs, Response} ->
	    Response
    end.

store(Key, Value) ->
    rpc({store, Key, Value}).

lookup(Key) ->
    rpc({lookup, Key}).

items() ->
    rpc(items).

stop() ->
    rpc(stop).

keys() ->
    rpc(keys).

loop() ->
    receive
	{From, {store, Key, Value}} ->
	    put(Key, {ok, Value}),
	    From ! {kvs, true},
	    loop();
	{From, {lookup, Key}} ->
	    From ! {kvs, get(Key)},
	    loop();
	{From, items} ->
	    %% From ! {kvs, get()},
	    From ! {kvs, [{K, V} || {K, {ok, V}} <- get()]},
	    loop();
	{From, keys} ->
	    From ! {kvs, [K || {K, {_, _}} <- get()]},
	    loop();
	{From, stop} ->
	    From ! {kvs, terminated}
    end.
