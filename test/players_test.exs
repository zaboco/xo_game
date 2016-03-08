defmodule PlayersTest do
  use ExUnit.Case
  alias Player.{Human, Computer, Stub}

  @moduletag :rewrite

  test "make reads type for each sign and creates players of the given type" do
    GameUI.impl.will_return read_player_type: ["h", "computer"]
    assert Players.make == {%Human{sign: :x}, %Computer{sign: :o}}
  end

  test "get_current_move gets the move from the current player" do
    players = {%Stub{sign: :x}, :other_player}
    move = Players.get_current_move(players, Board.empty(3))
    assert move == {Stub.move_index, :x}
  end

  test "swap" do
    assert {:second, :first} == Players.swap({:first, :second})
  end

  test "show_current" do
    players = {%Stub{sign: :x}, :other_player}
    shown = Players.show_current(players)
    assert shown == "x(stub)"
  end
end

