%% Author: Administrator
%% Created: 2012. 9. 25.
%% Description: TODO: Add description to event
-module(event).

%%
%% Include files
%%

%%
%% Exported Functions
%%
%% -export([start/2, start_link/2, cancel/1]).
-compile(export_all).

%%
%% Record Definitions
%%
-record(state, {server,
		name = "",
		to_go = 0}).

%%
%% API Functions
%%
start(EventName, DateTime = {{_,_,_}, {_,_,_}}) ->
    spawn(?MODULE, init, [self(), EventName, time_to_go(DateTime)]);
start(EventName, Delay) ->
    spawn(?MODULE, init, [self(), EventName, Delay]).

start_link(EventName, DateTime = {{_,_,_}, {_,_,_}}) ->
    spawn_link(?MODULE, init, [self(), EventName, time_to_go(DateTime)]);
start_link(EventName, Delay) ->
    spawn_link(?MODULE, init, [self(), EventName, Delay]).


cancel(Pid) ->
    Ref = erlang:monitor(process, Pid),
    Pid ! {self(), Ref, cancel},
    receive
	{Ref, ok} ->
	    erlang:demonitor(Ref, [flush]),
	    ok;
	{'DOWN', Ref, process, Pid, _Reason} ->
	    ok
    end.

%%
%% Local Functions
%%
init(Server, EventName, Delay) ->
    loop(#state{server = Server,
		name = EventName,
		to_go = normalize(Delay)}).

normalize(N) ->
    Limit = 49 * 24 * 60 * 60,		%% 49 days...
    [N rem Limit | lists:duplicate(N div Limit, Limit)].


loop(S = #state{server = Server, to_go = [T|Next]}) ->
    receive
	{Server, Ref, cancel} ->
	    Server ! {Ref, ok}
    after T * 1000 ->
	    if Next =:= [] ->
		    Server ! {done, S#state.name};
	       Next =/= [] ->
		    loop(S#state{to_go = Next})
	    end
    end.

time_to_go(TimeOut = {{_,_,_}, {_,_,_}}) ->
    Now = calendar:local_time(),
    ToGo = calendar:datetime_to_gregorian_seconds(TimeOut) -
	calendar:datetime_to_gregorian_seconds(Now),
    Secs = if ToGo > 0 -> ToGo;
	      ToGo =< 0 -> 0
	   end,
    Secs.
