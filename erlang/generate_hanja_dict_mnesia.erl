%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-

-module(generate_hanja_dict_mnesia).
-compile(export_all).

-include_lib("stdlib/include/qlc.hrl").


-record(hangul_hanja, {hangul, hanja, meaning}).
-record(hanja_hangul, {hanja, hangul, meaning}).


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

    mnesia:create_schema([node()]),
    mnesia:start(),
    mnesia:create_table(hangul_hanja, [{attributes, record_info(fields, hangul_hanja)},
				       {type, bag},
				       {disc_copies, [node()]}
				      ]),
    mnesia:create_table(hanja_hangul, [{attributes, record_info(fields, hanja_hangul)},
				       {type, set},
				       {disc_copies, [node()]}
				      ]),
    append_to_dets(WC2).


append_to_dets([]) ->
    io:format("~p~n", [mnesia:table_info(hangul_hanja, all)]),
    io:format("~p~n", [mnesia:table_info(hanja_hangul, all)]),
    mnesia:stop();
append_to_dets([H|T]) ->
    [Hangul, Hanja, Meaning] = H,
    HangulRow = #hangul_hanja{hangul=Hangul, hanja=Hanja, meaning=Meaning},
    HanjaRow  = #hanja_hangul{hanja=Hanja, hangul=Hangul, meaning=Meaning},
    F = fun() ->
		mnesia:write(HangulRow),
		mnesia:write(HanjaRow)
	end,
    mnesia:transaction(F),
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
    gen_dict("hanja.txt").


%%%%%%%%%%%%%%%%%%%%%%%%

start() ->
    mnesia:start(),
    mnesia:wait_for_tables([hangul_hanja, hanja_hangul], 20000).

stop() ->
    mnesia:stop().

do(Q) ->
    F = fun() -> qlc:e(Q) end,
    {atomic, Value} = mnesia:transaction(F),
    Value.

find_hangul(Hangul) ->
    do(qlc:q([X || X <- mnesia:table(hangul_hanja),
		   X#hangul_hanja.hangul =:= Hangul
	     ])).





%% vim: set ft=erlang et:
