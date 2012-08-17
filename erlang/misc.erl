%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-

-module(misc).
-compile(export_all).

-ifdef(debug).
-define(TRACE(X), io:format("TRACE ~p:~p ~p~n", [?MODULE, ?LINE, X])).
-else.
-define(TRACE(X), void).
-endif.

newline() ->
    io:format("~n").

prt(O) ->
    io:format("~p~n", [O]).

prt_str(Str) ->
    io:format(Str ++ "~n").

foreach(_, []) -> ok;
foreach(F, [H|T]) ->
    F(H),
    foreach(F, T).

mprt(L) ->
    foreach(fun prt/1, L).


sleep(T) ->
    receive
    after T ->
	    true
    end.

eval(S) ->
    eval(S, []).

eval(S, Environ) ->
    {ok, Scanned, _} = erl_scan:string(S ++ "."),
    {ok, Parsed} = erl_parse:parse_exprs(Scanned),
    {value, Value, _} = erl_eval:exprs(Parsed,Environ),
    Value.


range(N) ->
    Range = fun(X, _) when X =< 0 -> [];
	       (X, F) -> [X-1 | F(X-1, F)] end,
    lists:reverse(Range(N, Range)).


cnv(StrList, <<>>) -> lists:reverse(StrList);
cnv(StrList, BinStr) ->
    %% misc:prt(io:getopts()),
    %% misc:prt(BinStr),
    <<Ch/utf8,More/binary>> = BinStr,
    %% misc:prt(Ch),
    cnv([Ch | StrList], More).

convert_to_unicode(Str) ->
    BinStr = list_to_binary(Str),
    %% misc:prt(BinStr),
    cnv([], BinStr).

u(Str) -> convert_to_unicode(Str).

%% Encoding = latin1 / unicode
set_io_encoding(Encoding) ->
    io:setopts(standard_io, [{encoding, Encoding}]).
