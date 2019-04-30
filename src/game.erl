%%%-------------------------------------------------------------------
%%% @author agear
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Apr 2019 22:45
%%%-------------------------------------------------------------------
-module(game).
-author("agear").

%% API
-export([canWin/1, nextMove/1, explanation/0]).

% Assuming that the corner case of N = 0 means that the current player has no more matches to take, so he loses.
%canWin(0) -> false;
canWin(1) -> true;
canWin(2) -> true;
canWin(N) when (N > 0), (is_integer(N)) ->
  not canWin(N - 1) or not canWin(N - 2).



nextMove(1) -> {true, 1};
nextMove(2) -> {true, 2};
nextMove(3) -> false;
nextMove(N) when (N > 0), (is_integer(N))->
  case (not canWin(N - 1)) of
    true -> {true, 1};
    false ->
      case (not canWin(N - 2)) of
        true -> {true, 2};
        false -> false
      end
    end
.

explanation() ->
  io:format("Answer!!!!!!!!!!!!!!!!!!!").