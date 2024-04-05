-module(data_euclideanRing@foreign).
-export([intDegree/1, intDiv/2, intMod/2, numDiv/2]).

intDegree(X) -> erlang:abs(X).

intDiv(_, 0) -> 0;
intDiv(X, Y) when X < 0 -> (X - erlang:abs(Y) + 1) div (Y);
intDiv(X, Y) -> X div Y.

intMod(_, 0) -> 0;
intMod(X, Y) -> 
    YY = erlang:abs(Y),
    (X rem YY + YY) rem YY.

numDiv(X, Y) -> X / Y.
