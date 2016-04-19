defmodule PlayersTest do
  use ExUnit.Case, async: false
  alias Player.{Human, Computer, Stub}
  import MockIO.Test

  test "make reads type for each sign and creates players of the given type" do
    with_inputs ["h", "computer"] do
      assert Players.make == {{Human, :x}, {Computer, :o}}
    end
  end

  test "get_current_move gets the move from the current player" do
    players = {{Stub, :x}, :other_player}
    move = Players.get_current_move(players, Board.empty)
    assert move == {Stub.move_index, :x}
  end

  test "swap" do
    assert {:second, :first} == Players.swap({:first, :second})
  end

  test "show_current" do
    players = {{Stub, :x}, :other_player}
    shown = Players.show_current(players)
    assert shown == "x(stub)"
  end
end

