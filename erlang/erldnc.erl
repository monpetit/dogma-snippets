%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-

-module(erldnc).
%% -export([main/0, main/1]).
-compile(export_all).

prt(O) ->
    io:format("~p~n", [O]).

prt_str(Str) ->
    io:format(Str ++ "~n").


%% sleep(T) ->
%%     receive
%%     after T ->
%% 	    true
%%     end.

%% random_sleep(T) ->
%%     sleep(random:uniform(T)).


worker(Parent, Id) ->
    Parent ! {self(), ready},
    receive
	quit -> ok;
	{data, J2c} ->
	    convert_image(J2c, Id),
	    worker(Parent, Id)
    end.


convert_image(File, N) ->
    BaseName = filename:basename(File, ".j2c"),
    Bmp = (BaseName ++ ".bmp"),
    Cmd = "convert " ++ File ++ " " ++ Bmp,
    io:format("[~p] ~s~n", [N, Cmd]),
    %% prt_str(Cmd).
    os:cmd(Cmd).


%%
%% 메인 테스트...
%%
do_test(N) ->
    Pattern = "*.j2c",
    J2cs = filelib:wildcard(Pattern),
    prt(length(J2cs)),
    %% lists:map(fun prt/1, J2cs),
    Self = self(),
    Children = lists:map(
		 fun(X) ->
			 spawn(?MODULE, worker, [Self, X])
		 end, lists:seq(1, N)),
    prt(Children),
    loop(Children, J2cs).


loop([], []) -> ok;
loop(Children, []) ->
    receive
	{Child, ready} ->
	    Child ! quit,
	    loop(lists:delete(Child, Children), [])
    end;
loop(Children, [H|T]) ->
    receive
	{Child, ready} ->
	    Child ! {data, H},
	    loop(Children, T)
    end.


main() ->
    main([]).
main(N) when is_integer(N) ->
    do_test(N);
main([]) ->
    do_test(10);
main([H|_]) ->
    do_test(list_to_integer(H)).


