%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-

-module(area_server_final).
-export([start/0, area/2]).

start() -> spawn(fun area_service/0).

area(Pid, What) ->
    rpc(Pid, What).


shape_area({rectangle, Width, Height}) ->
    Width * Height;
shape_area({circle, R}) ->
    3.141592 * R * R.


area_service() ->
    receive
	{From, {rectangle, Width, Height} = X} ->
	    From ! {self(), shape_area(X)},
	    area_service();
	{From, {circle, R} = X} ->
	    From ! {self(), shape_area(X)},
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
