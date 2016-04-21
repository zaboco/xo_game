defmodule PlayersTest do
  use ExUnit.Case, async: false
  alias Player.{Human, Computer, Stub}

  test "with_types" do
    assert Players.with_types({"h", "comp"}) == {{Human, :x}, {Computer, :o}}
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

