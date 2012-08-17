%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-

-module(frequency).
-compile(export_all).

start() ->
    register(frequency, spawn(?MODULE, init, [])).

init() ->
    Frequencies = {get_frequencies(), []},
    loop(Frequencies).

get_frequencies() ->
    [10,11,12,13,14,15].


stop() -> call(stop).
allocate() -> call(allocate).
deallocate(Freq) -> call({deallocate, Freq}).

call(Message) ->
    frequency ! {request, self(), Message},
    receive
	{reply, Reply} -> Reply
    end.


loop(Frequencies) ->
    receive
	{request, From, allocate} ->
	    {NewFreq, Reply} = allocate(Frequencies, From),
	    reply(From, Reply),
	    loop(NewFreq);
	{request, From, {deallocate, Freq}} ->
	    NewFreq = deallocate(Frequencies, Freq),
	    reply(From, ok),
	    loop(NewFreq);
	{request, From, stop} ->
	    reply(From, ok)
    end,
    loop(petit).

reply(Pid, Reply) ->
    Pid ! {reply, Reply}.


allocate({[], Allocated}, _Pid) ->
    {{[], Allocated}, {error, no_frequency}};
allocate({[Freq|Free], Allocated}, Pid) ->
    {{Free, [{Freq, Pid} | Allocated]}, {ok, Freq}}.

deallocate({Free, Allocated}, Freq) ->
    NewAlloc = lists:keydelete(Freq, 1, Allocated),
    {[Freq|Free], NewAlloc}.
