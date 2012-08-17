-module(demo).
-export([double/1]).
-compile(export_all).


double(X) ->
    times(X, 2).

times(X, N) ->
    X * N.


ceil(X) ->
    trunc(X) + 1.
