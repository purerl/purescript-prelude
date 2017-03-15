-module(data_show@foreign).
-export([showIntImpl/1, showNumberImpl/1, showCharImpl/1, showStringImpl/1, showArrayImpl/2]).

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
    $\' -> <<"\\'"/utf8>>;
    $\" -> <<"\\\""/utf8>>;
    _ -> <<C/utf8>>
  end end,
  << "\""/utf8, << (Replace(C)) || <<C>> <= S >>/binary, "\""/utf8 >>.

showArrayImpl(F, XS) ->
  unicode:characters_to_binary(
  "[" ++
  string:join(lists:map(fun (X) -> unicode:characters_to_list(F(X)) end, array:to_list(XS)), ",") ++
  "]").
