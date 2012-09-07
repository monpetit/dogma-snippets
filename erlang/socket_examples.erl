%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-

-module(socket_examples).
-compile(export_all).


-define(TCP_PORT, 2345).
-define(PACKET_SPEC, {packet, 4}).



nano_get_url() ->
    nano_get_url("www.naver.com").

nano_get_url(Host) ->
    {ok, Socket} = gen_tcp:connect(Host, 80, [binary, {packet, 0}]),
    ok = gen_tcp:send(Socket, "GET / HTTP/1.0\r\n\r\n"),
    receive_data(Socket, []).

receive_data(Socket, SoFar) ->
    receive
	{tcp, Socket, Bin} ->
	    receive_data(Socket, [Bin|SoFar]);
	{tcp_closed, Socket} ->
	    list_to_binary(lists:reverse(SoFar))
    end.

get_contents_url(Host) ->
    mbcs:decode(binary_to_list(nano_get_url(Host)), utf8).

prt(Msg) ->
    io:format(Msg ++ "~n").
prt(Msg, Arg) ->
    io:format(Msg ++ " ~p~n", [Arg]).

encode(Bin) -> term_to_binary(Bin).
decode(Bin) -> binary_to_term(Bin).

new_listen() ->
    gen_tcp:listen(?TCP_PORT, [binary, ?PACKET_SPEC, {reuseaddr, true}, {active, true}]).


%% ===============================
%% server
%% ===============================

start_nano_server() ->
    {ok, Listen} = new_listen(),
    {ok, Socket} = gen_tcp:accept(Listen),
    gen_tcp:close(Listen),
    loop(Socket).

loop(Socket) ->
    receive
	{tcp, Socket, Bin} ->
	    prt("Server received binary =", Bin),
	    Str = decode(Bin),
	    prt("Server (unpacked)", Str),
	    Reply = misc:eval(Str),
	    prt("Server replying =", Reply),
	    gen_tcp:send(Socket, encode(Reply)),
	    loop(Socket);
	{tcp_closed, Socket} ->
	    prt("Server socket closed")
    end.


start_seq_server() ->
    {ok, Listen} = new_listen(),
    seq_loop(Listen).

seq_loop(Listen) ->
    {ok, Socket} = gen_tcp:accept(Listen),
    loop(Socket),
    seq_loop(Listen).


start_parallel_server() ->
    {ok, Listen} = new_listen(),
    spawn(?MODULE, par_connect, [Listen]).

par_connect(Listen) ->
    {ok, Socket} = gen_tcp:accept(Listen),
    spawn(?MODULE, par_connect, [Listen]),
    loop(Socket).



%% ===============================
%% client
%% ===============================

nano_client_eval(Str) ->
    {ok, Socket} = gen_tcp:connect("localhost", ?TCP_PORT, [binary, ?PACKET_SPEC]),
    ok = gen_tcp:send(Socket, encode(Str)),
    receive
	{tcp, Socket, Bin} ->
	    prt("Client received binary =", Bin),
	    Value = decode(Bin),
	    prt("Client result =", Value),
	    gen_tcp:close(Socket),
	    Value;
	{tcp_closed, Socket} ->
	    prt("Client socket closed")
    end.


%% =========
%% test
%% =========
%% > socket_examples:start_nano_server().
%% > socket_examples:nano_client_eval("X = list_to_tuple([1,3,-3*43,5*34]), misc:prt(X), Y = tuple_to_list(X), lists:map(fun misc:prt/1, Y)").

%% vim: set ft=erlang et:
