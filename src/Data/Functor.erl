% module Data.Functor
-module(data_functor@foreign).
-export([arrayMap/1]).

arrayMap(F) ->
  fun (Arr) ->
    array:map(fun (_,X) -> F(X) end, Arr)
  end.
