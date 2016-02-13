defmodule BoardTest do
  use ExUnit.Case
  import Board

  @some_board [
    [:x, 1, 2],
    [:o, 4, 5],
    [6, 7, 8],
  ]

  test "sigil b transforms a colon-delimited string into a board" do
    assert ~b|x _ _ : o _ _ : _ _ _| == @some_board
  end

  test "sigil B uses newline as a delimiter" do
    assert ~B"""
      x _ _
      o _ _
      _ _ _
    """ == @some_board
  end

  test "fill_cell replaces voids with signs" do
    input = ~b|x _ _ : o _ _ : _ _ _|
    expected = ~b|x x _ : o _ _ : _ _ _|
    assert Board.fill_cell(input, at: 1, with: :x) == {:ok, expected}
  end

  test "fill_cell does nothing when cell is already filled" do
    input = ~b|x _ _ : o _ _ : _ _ _|
    assert Board.fill_cell(input, at: 0, with: :x) == {:error, "Invalid cell: 0"}
    assert Board.fill_cell(input, at: 10, with: :x) == {:error, "Invalid cell: 10"}
  end

  test "replace voids with indexes in list" do
    assert Board.fill_list_with_indexes([:_, :_, :_]) == [0, 1, 2]
    assert Board.fill_list_with_indexes([:_, :x, :_]) == [0, :x, 2]
    assert Board.fill_list_with_indexes([:_, :_, :_], 3) == [3, 4, 5]
  end

  test "replace voids with indexes in matrix" do
    matrix = [[:x, :_, :_], [:o, :_, :_]]
    expected = [[:x, 1, 2], [:o, 4, 5]]
    assert Board.fill_matrix_with_indexes(matrix, 3) == expected
  end
end
