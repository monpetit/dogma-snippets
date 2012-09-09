%% -*- mode: erlang -*-
%% -*- coding: utf-8 -*-

-module(fileutils).
-compile(export_all).

ls(Dir) ->
    file:list_dir(Dir).

add_sub_dir(Dir) -> add_sub_dir(Dir, []).

add_sub_dir(Dir, Result) ->
    {ok, Ls} = ls(Dir),
    LsInfo = lists:map(
	       fun(F) ->
		       Path = filename:join(Dir, F), %% Dir ++ "/" ++ F,
		       {ok, Fi} = file:read_file_info(Path),
		       {Path, Fi}
	       end, Ls),
    SubDir = lists:filter(
	       fun({_Path, Fi}) ->
		       element(3, Fi) =:= directory
	       end, LsInfo),
    SD = lists:map(fun(D) -> element(1, D) end, SubDir),
    lists:foreach(fun(D) ->
			  {ok, RE} = re:compile(".*ebin$"),
			  case re:run(D, RE) of
			      {match, _} -> io:format("~p added in code path~n", [D]),
					    code:add_pathz(D);
			      _ -> nil
			  end
		  end, SD),

    case length(SD) of
	0 -> Dir;
	_ -> lists:map(fun(D) -> add_sub_dir(D, [Dir|Result]) end, SD)
    end.
