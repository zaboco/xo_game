defmodule GameStateTest do
  use ExUnit.Case

  test "starts in_progress, with empty board and with given players" do
    players = [{:x, :human}, {:o, :computer}]
    assert GameState.initial(players) == {Board.empty, players}
  end
end
