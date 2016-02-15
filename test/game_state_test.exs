defmodule GameStateTest do
  use ExUnit.Case
  import :meck
  import Board

  test "starts with empty board and with given players" do
    players = [{:x, :human}, {:o, :computer}]
    assert GameState.initial(players) == {Board.empty, players}
  end

  test "apply_move" do
    expect Board, :fill_cell, [:board, [at: 2, with: :x]], {:ok, :new_board}
    new_state = GameState.apply_move {:board, :players}, {2, :x}
    assert new_state == {:new_board, :players}
    unload Board
  end

  test "check_status returns :win if any row is a winner" do
    assert GameState.check_status(~b|x x x : _ _ _ : _ _ _|) == :win
    assert GameState.check_status(~b|_ _ _ : o o o : _ _ _|) == :win
    assert GameState.check_status(~b|_ _ _ : o x o : x x x|) == :win
  end

  test "check_status returns :win if any column is a winner" do
    assert GameState.check_status(~b|x _ _ : x _ _ : x _ _|) == :win
    assert GameState.check_status(~b|_ o _ : _ o _ : _ o _|) == :win
  end

  test "check_status returns :win if any diagonal is a winner" do
    assert GameState.check_status(~b|x _ _ : _ x _ : _ _ x|) == :win
    assert GameState.check_status(~b|_ _ o : _ o _ : o _ _|) == :win
  end

  test "check_status returns :tie if no winner and the board is full" do
    assert GameState.check_status(~B"""
      x o x
      o x o
      o x o
    """) == :tie
  end

  test "check_status returns :in_progress if neither :win nor :tie" do
    assert GameState.check_status(~B"""
      x o x
      o x o
      o x _
    """) == :in_progress
  end
end
