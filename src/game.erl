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

%canWin(0) -> false;
canWin(1) -> true;
canWin(2) -> true;
canWin(N) when (N > 0), (is_integer(N)) ->
  not canWin(N - 1) or not canWin(N - 2).


%nextMove(0) -> false;
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

explanation() -> {"The difficulty to provide a tail recursion solution is that it's not that intuitive to do so. "
                  "We've seen in class that tail recurcion is possible, by solving a similar problem (Fibonacci series)"
                  " that has the same recursive solution and the same boundary values problem."}.