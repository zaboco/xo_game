defmodule BoardTest do
  use ExUnit.Case
  import Board.Sigils

  @empty_board  Board.empty
  @some_board   ~b|x _ _ : _ o _ : _ _ x|

  ## to_matrix
  test "to_matrix returns indexes for empty cells" do
    expected_matrix = [[0, 1, 2], [3, 4, 5], [6, 7, 8]]
    assert @empty_board |> Board.to_matrix == expected_matrix
  end

  test "to_matrix returns actual signs for filled cells" do
    expected_matrix = [[:x, 1, 2], [3, :o, 5], [6, 7, :x]]
    assert @some_board |> Board.to_matrix == expected_matrix
  end

  test "to_matrix can modify void cells' representation" do
    expected_matrix = [[:x, 2, 3], [4, :o, 6], [7, 8, :x]]
    assert @some_board |> Board.to_matrix(& &1 + 1) == expected_matrix
  end


  ## put
  test "puts a sign in the cell if it is empty" do
    expected_board = ~b|x x _ : _ o _ : _ _ x|
    assert @some_board |> Board.put(1, :x) == expected_board
  end

  test "put leaves the board unchanged if the cell is filled" do
    assert @some_board |> Board.put(0, :o) == @some_board
  end

  test "put also does nothing when the index is invalid" do
    assert @some_board |> Board.put(20, :x) == @some_board
    assert @some_board |> Board.put(-5, :x) == @some_board
  end

  test "put returns :error if the index is not an integer" do
    assert @some_board |> Board.put(:not_an_index, :x) == :error
  end

  test "indexes_where" do
    assert @some_board |> Board.indexes_where(& not is_nil &1) == [0, 4, 8]
  end

  ## check_status
  test "status is :win if any row, column or diagonal is aligned" do
    for board <- [
      # rows
      ~b|x x x : _ _ _ : _ _ _|,
      ~b|_ _ _ : o o o : _ _ _|,
      ~b|x o o : o o x : x x x|,

      #columns
      ~b|
        x _ _
        x _ o
        x o _|,
      ~b|
        x o _
        _ o _
        x o _|,
      ~b|
        _ x o
        _ _ o
        _ x o|,

      #diagonals
      ~b|
        x _ o
        _ x _
        o _ x|,
      ~b|
        x _ o
        _ o _
        o _ x|,
    ] do
      assert board |> Board.check_status == :win
    end
  end

  test "status is :tie if it's no winner and the board is full" do
    tie_board = ~b|
      x o x
      o x o
      o x o|
    assert tie_board |> Board.check_status == :tie
  end

  test "status is :in_progress if neither :win nor :tie" do
    allmost_full_board = ~b|
      x o x
      o x o
      o x _|
    assert allmost_full_board |> Board.check_status == :in_progress
    assert @empty_board |> Board.check_status == :in_progress
  end
end


