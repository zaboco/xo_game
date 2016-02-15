defmodule Players.HumanTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  import MeckUtils, only: [with_inputs: 2]
  import Board
  alias Players.Human

  test "read_move shows the board asking for a move" do
    with_inputs ["0"], fn ->
      prompt = capture_io fn -> Human.read_move(Board.empty, :sign) end
      expected_prompt = """
      +---+---+---+
      | 0 | 1 | 2 |
      +---+---+---+
      | 3 | 4 | 5 |
      +---+---+---+
      | 6 | 7 | 8 |
      +---+---+---+
      """
      assert String.strip(prompt) == String.strip(expected_prompt)
    end
  end

  @board ~b|_ x _ : _ _ _ : _ _ _|
  test "read_move returns the chosen move if valid" do
    with_inputs ["0\n"], fn ->
      assert Human.read_move(@board, :sign) == {0, :sign}
    end
  end

  test "read_move asks for moves until valid" do
    with_inputs ["9\n", "2\n"], fn ->
      assert Human.read_move(@board, :sign) == {2, :sign}
    end

    with_inputs ["1\n", "3\n"], fn ->
      assert Human.read_move(@board, :sign) == {3, :sign}
    end

    with_inputs ["a\n", "4\n"], fn ->
      assert Human.read_move(@board, :sign) == {4, :sign}
    end
  end
end
