defmodule GameStateTest do
  use ExUnit.Case
  import :meck

  test "starts in_progress, with empty board and with given players" do
    players = [{:x, :human}, {:o, :computer}]
    assert GameState.initial(players) == {Board.empty, players}
  end

  test "apply_move" do
    expect Board, :fill_cell, [:board, [at: 2, with: :x]], :new_board
    new_state = GameState.apply_move {:board, :players}, {2, :x}
    assert new_state == {:new_board, :players}
  end
end
