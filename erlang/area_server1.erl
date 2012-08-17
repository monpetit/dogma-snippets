%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-

-module(area_server1).
-export([area_service/0, rpc/2]).


area({rectangle, Width, Height}) ->
    Width * Height;
area({circle, R}) ->
    3.141592 * R * R.


area_service() ->
    receive
	{From, {rectangle, Width, Height} = X} ->
	    From ! {self(), area(X)},
	    area_service();
	{From, {circle, R} = X} ->
	    From ! {self(), area(X)},
	    area_service();
	{From, Other} ->
	    From ! {self(), {error, Other}},
	    area_service()
    end.


rpc(Pid, Request) ->
    Pid ! {self(), Request},
    receive
	{Pid, Response} ->
	    Response
    end.

% vim: set ft=erlang et:
