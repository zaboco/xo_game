defmodule PlayersTest do
  use ExUnit.Case
  import :meck

  test "get_move dispatches to actual implementation for each player type" do
    expect Players.Human, :read_move, [:board, :sign], :human_move
    assert Players.get_move(:board, {:sign, :human}) == :human_move

    expect Players.Computer, :calculate_move, 2, :computer_move
    assert Players.get_move(:board, {:sign, :computer}) == :computer_move
    unload
  end
end
