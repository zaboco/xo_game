defmodule BoardTest do
  use ExUnit.Case
  import Matrix.Sigils, only: [sigil_m: 2]

  @moduletag :rewrite

  @empty_board  Board.empty(3)
  @some_board   Board.new ~m|x _ _ : _ o _ : _ _ x|

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
    expected_board = Board.new ~m|x x _ : _ o _ : _ _ x|
    assert @some_board |> Board.put(1, :x) == expected_board
  end

  test "put leaves the board unchanged if the cell is filled" do
    assert @some_board |> Board.put(0, :x) == @some_board
  end

  test "put also does nothing when the index is invalid" do
    assert @some_board |> Board.put(20, :x) == @some_board
    assert @some_board |> Board.put(-5, :x) == @some_board
    assert @some_board |> Board.put(:not_an_index, :x) == @some_board
  end

  ## empty_at?
  test "empy_at? ok" do
    assert @some_board |> Board.empty_at?(1) == true
  end

  test "empty_at? false for filled cell" do
    assert @some_board |> Board.empty_at?(0) == false
  end

  test "empty_at? false for outbound index" do
    assert @some_board |> Board.empty_at?(10) == false
    assert @some_board |> Board.empty_at?(-2) == false
  end

  ## check_status
  test "status is :win if any row, column or diagonal is aligned" do
    for board_rows <- [
      # rows
      ~m|x x x : _ _ _ : _ _ _|,
      ~m|_ _ _ : o o o : _ _ _|,
      ~m|x o o : o o x : x x x|,

      #columns
      ~m|
        x _ _
        x _ o
        x o _|,
      ~m|
        x o _
        _ o _
        x o _|,
      ~m|
        _ x o
        _ _ o
        _ x o|,

      #diagonals
      ~m|
        x _ o
        _ x _
        o _ x|,
      ~m|
        x _ o
        _ o _
        o _ x|,
    ] do
      status = board_rows |> Board.new |> Board.check_status
      assert status == :win
    end
  end

  test "status is :tie if it's no winner and the board is full" do
    tie_board = Board.new ~m|
      x o x
      o x o
      o x o|
    assert tie_board |> Board.check_status == :tie
  end

  test "status is :in_progress if neither :win nor :tie" do
    allmost_full_board = Board.new ~m|
      x o x
      o x o
      o x _|
    assert allmost_full_board |> Board.check_status == :in_progress
    assert @empty_board |> Board.check_status == :in_progress
  end
end


