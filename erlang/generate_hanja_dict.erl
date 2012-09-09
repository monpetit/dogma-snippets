%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-

-module(generate_hanja_dict).
%% -export([main/0, main/1]).
-compile(export_all).

-define(HANJA_DICT_FILE, "hanja_dict.dets").


gen_dict(RawFile) ->
    {ok, BinData} = file:read_file(RawFile),
    UnicodeData = mbcs:decode(binary_to_list(BinData), utf8),
    WordList = string:tokens(UnicodeData, "\n"),
    WL2 = lists:filter(
	    fun(W) -> Line = string:strip(W, both, $\r),
		      ((length(Line) > 0) andalso (hd(Line) =/= $#))
	    end, WordList),
    WordCards = lists:map(
		  fun(W) ->
			  string:tokens(W, ":")
		  end, WL2),
    WC2 = lists:map(
	    fun([Hj,Hg,M]) ->
		    [Hj, Hg, term_to_binary(string:strip(M, both, $\r))]
	    end, WordCards),
    {ok, ?MODULE} = dets:open_file(?MODULE, [{file, ?HANJA_DICT_FILE}, {type, bag}]),
    append_to_dets(WC2).


append_to_dets([]) ->
    io:format("~p~n", [dets:info(?MODULE)]),
    dets:close(?MODULE);
append_to_dets([H|T]) ->
    [Hangul, Hanja, Meaning] = H,
    dets:insert(?MODULE, {Hangul, Hanja, Meaning}),
    dets:insert(?MODULE, {Hanja, Hangul, Meaning}),
    append_to_dets(T).

    %% Case length(H) of
    %% 	3 ->
    %% 	    [Hangul, Hanja, Meaning] = H,
    %% 	    dets:insert(?MODULE, {Hangul, Hanja, Meaning}),
    %% 	    dets:insert(?MODULE, {Hanja, Hangul, Meaning});
    %% 	_ ->
    %% 	    nothing
    %% end,
    %% append_to_dets(T).


main() ->
    main(none).

main(_) ->
    Bool = filelib:is_file(?HANJA_DICT_FILE),
    case Bool of
	true -> io:format("~p~n", [{error, "file exist."}]),
		quit;
	false ->
	    gen_dict("hanja.txt")
    end.


%% vim: set ft=erlang et:
