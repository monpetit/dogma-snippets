%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-


%%
%% zeromq의 event-worker-sync 모델을 이용한
%% 병렬 작업 예제
%%

-module(dnq).
-export([main/0, main/1]).

prt_str(Str) ->
    io:format(Str ++ "~n").

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syncer(Context, N) ->
    {ok, Receiver} = erlzmq:socket(Context, pull),
    %% put(syncer_receiver, Receiver),
    ok = erlzmq:bind(Receiver, "tcp://*:5556"),

    Start = now(),

    %% Process 100 confirmations
    process_confirmations(Receiver, N),

    %% Calculate and report duration of batch
    io:format("Total elapsed time: ~b msec~n",
              [timer:now_diff(now(), Start) div 1000]),

    mainproc ! ok,

    ok = erlzmq:close(Receiver),
    % ok = erlzmq:term(Context),
    prt_str("syncer end!").


process_confirmations(_Receiver, 0) -> ok;
process_confirmations(Receiver, N) when N > 0 ->
    {ok, _} = erlzmq:recv(Receiver),
    process_confirmations(Receiver, N - 1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

worker(Context, N) ->
    %% Socket to receive messages on
    {ok ,Receiver} = erlzmq:socket(Context, pull),
    %% put(worker_receiver, Receiver),
    ok = erlzmq:connect(Receiver, "tcp://localhost:5555"),

    %% Socket to send messages to
    {ok, Sender} = erlzmq:socket(Context, push),
    %% put(worker_sender, Sender),
    ok = erlzmq:connect(Sender, "tcp://localhost:5556"),

    %% Process tasks forever
    loop(Receiver, Sender, N).

loop(Receiver, Sender, N) ->
    {ok, Txt} = erlzmq:recv(Receiver),

    io:format("[~b] ~p~n", [N, binary_to_list(Txt)]),

    %% Send results to sink
    ok = erlzmq:send(Sender, <<"">>),

    loop(Receiver, Sender, N).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

main() ->
    main(["10"]).

main([]) ->
    main();
main(TCount) ->
    Txts = filelib:wildcard("*.txt"),
    {NumOfThreads, _} = string:to_integer(hd(TCount)),
    {ok, Context} = erlzmq:context(),

    Sync = spawn(fun() ->
			 syncer(Context, length(Txts))
		 end),

    lists:foreach(
      fun(N) ->
	      spawn(fun() ->
			    worker(Context, N)
		    end)
      end, lists:seq(1, NumOfThreads)),

    {ok, Sender} = erlzmq:socket(Context, push),
    ok = erlzmq:bind(Sender, "tcp://*:5555"),

    send_tasks(Sender, Txts),

    register(mainproc, self()),
    receive
        _ -> prt_str("program exit!")
             %% unregister(mainproc),
	     %% erlzmq:close(get(syncer_receiver)),
	     %% erlzmq:close(get(worker_receiver)),
	     %% erlzmq:close(get(worker_sender)),
	     %% erlzmq:close(Sender),
	     %% erlzmq:term(Context)
    end.


send_tasks(_, []) -> ok;
send_tasks(Sender, [H|T]) ->
    ok = erlzmq:send(Sender, list_to_binary(H)),
    send_tasks(Sender, T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


