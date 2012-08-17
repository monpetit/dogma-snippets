%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-

-module(udp_test).
-compile(export_all).

client(Msg) ->
    {ok, Socket} = gen_udp:open(0, [binary]),
    io:format("client opened socket = ~p~n", [Socket]),
    ok = gen_udp:send(Socket, "localhost", 45454,
		      list_to_binary(Msg)),
    gen_udp:close(Socket).

play() ->
    client("play").

stop() ->
    client("stop").

pause() ->
    client("pause").

quit() ->
    client("quit").
