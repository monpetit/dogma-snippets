%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-

-module(area_server0).
%% -compile(export_all).
-export([area_service/0]).


area({rectangle, Width, Height}) ->
    Width * Height;
area({circle, R}) ->
    3.141592 * R * R.


area_service() ->
    receive
	{rectangle, Width, Height} = X ->
	    io:format("Area of ~p is ~p.~n", [rectangle, area(X)]),
	    area_service();
	{circle, R} = X ->
	    io:format("Area of ~p is ~p.~n", [circle, area(X)]),
	    area_service();
	Other ->
	    io:format("I don't know what the area of a ~p is.~n", [Other]),
	    area_service()
    end.


% vim: set ft=erlang et:
