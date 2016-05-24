defmodule Player.HumanTest do
  use ExUnit.Case, async: false
  alias Player.Human
  import ExUnit.CaptureIO

  @empty_board Board.empty
  @x_human {Human, :x}

  test "get_move displays the board with indexes" do
    output = capture_io [input: "1", capture_prompt: false], fn ->
      Player.get_move(@x_human, Board.empty)
    end
    assert output == """
      +---+---+---+
      | 1 | 2 | 3 |
      +---+---+---+
      | 4 | 5 | 6 |
      +---+---+---+
      | 7 | 8 | 9 |
      +---+---+---+
      """
  end

  test "get_move uses the given index if valid" do
    capture_io "1", fn ->
      assert @x_human |> Player.get_move(@empty_board) == {0, :x}
    end
  end

  test "get_move reads the index again if not a digit" do
    capture_io "a\n1", fn ->
      assert @x_human |> Player.get_move(@empty_board) == {0, :x}
    end
  end

  test "get_move reads the index again if cell not empty" do
    board = @empty_board |> Board.put(0, :x)
    capture_io "1\n2", fn ->
      assert @x_human |> Player.get_move(board) == {1, :x}
    end
  end

  test "get_move reads the index again if out of bounds" do
    capture_io "0\n4", fn ->
      assert @x_human |> Player.get_move(@empty_board) == {3, :x}
    end
  end

  test "get_move logs error message if wrong index" do
    output = capture_io "0\n4", fn ->
      @x_human |> Player.get_move(@empty_board)
    end
    assert String.contains? output, "wrong_index: 0\n"
  end

  test "show" do
    assert @x_human |> Player.show == "x(human)"
  end
end
