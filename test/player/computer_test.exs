defmodule Player.ComputerTest do
  use ExUnit.Case
  import Matrix.Sigils
  alias Player.{Move, Computer}
  alias Computer.{Score, Choice}

  test "1 empty cell: score is zero if move results in a tie" do
    board = Board.new ~m|
      _ o x
      o o x
      x x o|
    assert Choice.evaluate(choice_of 0, board) == Score.zero
  end

  test "1 empty cell: score is max for winner move" do
    board = Board.new ~m|
      _ o x
      x o o
      x x o|
    assert Choice.evaluate(choice_of 0, board) == Score.max
  end

  test "2 empty cells: score is max for winner move" do
    board = Board.new ~m|
      _ _ x
      x o o
      x x o|
    assert Choice.evaluate(choice_of 0, board, :o) == Score.max
  end

  test "2 empty cells: score is min if opponent wins in the next round" do
    board = Board.new ~m|
      _ _ x
      x o o
      x x o|
    assert Choice.evaluate(choice_of 1, board, :o) == Score.min
  end

  test "2 empty cells: score is zero if opponent's move would be a tie" do
    board = Board.new ~m|
      _ _ x
      o x x
      o x o|
    assert Choice.evaluate(choice_of 1, board, :o) == Score.zero
  end

  test "get_move_index" do
    board = Board.new ~m|
      _ _ x
      o x x
      o x o|
    assert Computer.get_move_index(:x, board) == 1
  end

  defp choice_of(index, board, sign \\ :x) do
    Choice.new board, Move.new(index, sign)
  end
end
