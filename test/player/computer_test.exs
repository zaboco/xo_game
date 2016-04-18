defmodule Player.ComputerTest do
  use ExUnit.Case
  import Board.Sigils
  alias Player.{Move, Computer}
  alias Computer.{Score, Choice}

  test "1 empty cell: score is zero if move results in a tie" do
    board = ~b|
      _ o x
      o o x
      x x o|
    assert Choice.evaluate(choice_of 0, board) == Score.zero
  end

  test "1 empty cell: score is max for winner move" do
    board = ~b|
      _ o x
      x o o
      x x o|
    assert Choice.evaluate(choice_of 0, board) == Score.max
  end

  test "2 empty cells: score is max for winner move" do
    board = ~b|
      _ _ x
      x o o
      x x o|
    assert Choice.evaluate(choice_of 0, board, :o) == Score.max
  end

  test "2 empty cells: score is min if opponent wins in the next round" do
    board = ~b|
      _ _ x
      x o o
      x x o|
    assert Choice.evaluate(choice_of 1, board, :o) == Score.min
  end

  test "2 empty cells: score is zero if opponent's move would be a tie" do
    board = ~b|
      _ _ x
      o x x
      o x o|
    assert Choice.evaluate(choice_of 1, board, :o) == Score.zero
  end

  test "get_move_index returns index of best choice" do
    board = ~b|
      _ _ x
      o x x
      o x o|
    assert Computer.get_move_index(:x, board) == 1
  end

  test "get_move_index returns index of immediate win" do
    board = ~b|
      o o x
      _ _ _
      _ _ x|
    assert Computer.get_move_index(:x, board) == 5
  end

  @corners [0, 2, 6, 8]
  test "get_move_index is a corner for empty board" do
    board = Board.empty
    assert Computer.get_move_index(:x, board) in @corners
  end

  test "get_move_index is the center for one-cell board with empty center" do
    board = ~b|
      x _ _
      _ _ _
      _ _ _|
    assert Computer.get_move_index(:o, board) == 4
  end

  test "get_move_index is a corner for board with only one cell, when center" do
    board = ~b|
      _ _ _
      _ x _
      _ _ _|
    assert Computer.get_move_index(:o, board) in @corners
  end

  test "score_matrix" do
    board = ~b|
      o _ x
      _ x _
      o _ _|
    assert Computer.score_matrix(board, :x) == [
      [:o, -1, :x],
      [ 0, :x, -1],
      [:o, -1, -1]
    ]
  end

  defp choice_of(index, board, sign \\ :x) do
    Choice.new board, Move.new(index, sign)
  end
end
