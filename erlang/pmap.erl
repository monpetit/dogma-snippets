%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-

-module(pmap).
-export([pmap/2, npmap/3]).

%% Applies the function Fun to each element of the list in parallel
pmap(Fun, List) ->
  Parent = self(),
  %% spawn the processes
  Refs =
      lists:map(
        fun(Elem) ->
                Ref = make_ref(),
                spawn(
                  fun() ->
                          Parent ! {Ref, Fun(Elem)}
                  end),
                Ref
        end, List),

  %% collect the results
  lists:map(
    fun(Ref) ->
            receive
                {Ref, Elem} ->
                    Elem
            end
    end, Refs).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sub_list([], _) -> [];
sub_list(L, N) ->
    Len = min(length(L), N),
    {H,T} = lists:split(Len, L),
    [H | sub_list(T, N)].


%%% 개선할 여지 있음! 
%%% 각 서브리스트의 연산이 다 끝날 때까지 기다리는 문제!

npmap(F, L, K) ->
    SubList = sub_list(L, K),
    %% prt(SubList),
    lists:flatten(lists:map(fun(X) -> pmap(F, X) end, SubList)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

