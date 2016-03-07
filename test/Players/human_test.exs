defmodule Players.HumanTest do
  use ExUnit.Case
  alias Players.Human
  alias Doubles.FakeUI

  @moduletag :rewrite

  @empty_board Board.empty(3)
  @x_human %Human{sign: :x}

  setup_all do
    Application.put_env(:xo_game, :ui, FakeUI)
  end

  setup do
    FakeUI.init
    :ok
  end

  test "get_move displays the board with indexes" do
    Player.get_move(@x_human, Board.empty(3))
    assert_received {:print_matrix, [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
      ]}
  end

  test "get_move uses the given index if valid" do
    FakeUI.will_return read_index: ["1"]
    assert @x_human |> Player.get_move(@empty_board) == {0, :x}
  end

  test "get_move reads the index again if not a digit" do
    FakeUI.will_return read_index: ["a", "1"]
    assert @x_human |> Player.get_move(@empty_board) == {0, :x}
  end

  test "get_move reads the index again if cell not empty" do
    board = @empty_board |> Board.put(0, :x)
    FakeUI.will_return read_index: ["1", "2"]
    assert @x_human |> Player.get_move(board) == {1, :x}
  end

  test "get_move reads the index again if out of bounds" do
    FakeUI.will_return read_index: ["0", "4"]
    assert @x_human |> Player.get_move(@empty_board) == {3, :x}
  end

  test "get_move logs error message if wrong index" do
    FakeUI.will_return read_index: ["0", "4"]
    @x_human |> Player.get_move(@empty_board)
    assert_received {:log, [:wrong_index, "0"]}
  end

  test "show" do
    assert @x_human |> Player.show == "x(human)"
  end
end
