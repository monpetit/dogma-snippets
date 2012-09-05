%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-

-module(kvs2).
-compile(export_all).

start() -> catch(register(kvs2, spawn(?MODULE, loop, [dict:new()]))).

rpc(Req) ->
    kvs2 ! {self(), Req},
    receive
	{kvs2, Reply} ->
	    Reply
    end.

store(Key, Value) ->
    rpc({store, Key, Value}).

lookup(Key) ->
    rpc({lookup, Key}).

find(Key) -> lookup(Key).

erase(Key) ->
    rpc({erase, Key}).

keys() ->
    rpc(fetch_keys).

to_list() ->
    rpc(to_list).

stop() ->
    catch(rpc(stop)).


loop(Dict) ->
    receive
	{From, {store, Key, Value}} ->
	    NewDict = dict:store(Key, Value, Dict),
	    From ! {kvs2, true},
	    loop(NewDict);
	{From, {lookup, Key}} ->
	    From ! {kvs2, dict:find(Key, Dict)},
	    loop(Dict);
	{From, {erase, Key}} ->
	    NewDict = dict:erase(Key, Dict),
	    From ! {kvs2, ok},
	    loop(NewDict);
	{From, fetch_keys} ->
	    From ! {kvs2, dict:fetch_keys(Dict)},
	    loop(Dict);
	{From, to_list} ->
	    From ! {kvs2, dict:to_list(Dict)},
	    loop(Dict);
	{From, stop} ->
	    From ! {kvs2, terminated};
	{From, _} ->
	    From ! {kvs2, {error, unknown_command}},
	    loop(Dict)
    end.
