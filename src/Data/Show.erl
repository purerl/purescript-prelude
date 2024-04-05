-module(data_show@foreign).
-export([showIntImpl/1, showNumberImpl/1, showCharImpl/1, showStringImpl/1, showArrayImpl/2, cons/2, join/2]).

showIntImpl(N) -> integer_to_binary(N).
showNumberImpl(N) -> float_to_binary(N).
showCharImpl(C) ->
  case C of
    $\b -> <<"'\\b'"/utf8>>;
    $\f -> <<"'\\f'"/utf8>>;
    $\n -> <<"'\\n'"/utf8>>;
    $\r -> <<"'\\r'"/utf8>>;
    $\t -> <<"'\\t'"/utf8>>;
    $\v -> <<"'\\v'"/utf8>>;
    N when N < 16#20; N == 16#7F -> <<"'\\"/utf8, N/utf8, "'"/utf8>>;
    C when C == $\'; C == $\\ -> <<"'\\"/utf8, C/utf8, "'"/utf8>>;
    C -> <<$\', C/utf8, $\'>>
  end.

showStringImpl(S) ->
  Replace = fun (C) -> case C of
    $\b -> <<"\\b"/utf8>>;
    $\f -> <<"\\f"/utf8>>;
    $\n -> <<"\\n"/utf8>>;
    $\r -> <<"\\r"/utf8>>;
    $\t -> <<"\\t"/utf8>>;
    $\v -> <<"\\v"/utf8>>;
    $\" -> <<"\\\""/utf8>>;
    _ -> <<C/utf8>>
  end end,
  << "\""/utf8, << (Replace(C)) || <<C>> <= S >>/binary, "\""/utf8 >>.

join(Separator, Xs, F) -> unicode:characters_to_binary(
  lists:join(unicode:characters_to_list(Separator), 
    lists:map(fun (X) -> unicode:characters_to_list(F(X)) end, array:to_list(Xs)))).

showArrayImpl(F, Xs) ->
  S = join(",", Xs, F),
  <<"["/utf8, S/binary, "]"/utf8>>.

cons(Head, Tail) -> array:from_list([Head|array:to_list(Tail)]).
join(Separator, Xs) -> join(Separator, Xs, fun (X) -> X end).
