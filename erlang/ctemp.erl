%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-

-module(ctemp).
-compile(export_all).

start() ->
    spawn(?MODULE, loop, [[]]).

rpc(Pid, Request) ->
    Pid ! {self(), Request},
    receive
        {Pid, Response} ->
            Response
    after 1000 ->
            no_response
    end.

loop(X) ->
    receive
        AnyMsg ->
	    io:format("Received: ~p~n", [AnyMsg]),
	    loop(X)
    end.

