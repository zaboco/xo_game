defmodule Player.HumanTest do
  use ExUnit.Case, async: false
  alias Player.Human
  import MockIO.Test

  @empty_board Board.empty
  @x_human {Human, :x}

  test "get_move displays the board with indexes" do
    with_inputs ["1"] do
      Player.get_move(@x_human, Board.empty)
      assert_output """
        +---+---+---+
        | 1 | 2 | 3 |
        +---+---+---+
        | 4 | 5 | 6 |
        +---+---+---+
        | 7 | 8 | 9 |
        +---+---+---+
        """
    end
  end

  test "get_move uses the given index if valid" do
    with_inputs ["1"] do
      assert @x_human |> Player.get_move(@empty_board) == {0, :x}
    end
  end

  test "get_move reads the index again if not a digit" do
    with_inputs ["a", "1"] do
      assert @x_human |> Player.get_move(@empty_board) == {0, :x}
    end
  end

  test "get_move reads the index again if cell not empty" do
    board = @empty_board |> Board.put(0, :x)
    with_inputs ["1", "2"] do
      assert @x_human |> Player.get_move(board) == {1, :x}
    end
  end

  test "get_move reads the index again if out of bounds" do
    with_inputs ["0", "4"] do
      assert @x_human |> Player.get_move(@empty_board) == {3, :x}
    end
  end

  test "get_move logs error message if wrong index" do
    with_inputs ["0", "4"] do
      @x_human |> Player.get_move(@empty_board)
      assert_output "wrong_index: 0\n"
    end
  end

  test "show" do
    assert @x_human |> Player.show == "x(human)"
  end
end
