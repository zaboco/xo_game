defmodule PlayersTest do
  use ExUnit.Case
  alias Players.{Human, Computer}

  @moduletag :rewrite

  test "make reads type for each sign and creates players of the given type" do
    GameUI.impl.will_return read_player_type: ["h", "computer"]
    assert Players.make == {%Human{sign: :x}, %Computer{sign: :o}}
  end

  test "get_current_move gets the move from the current player" do
    players = {%PlayerStub{sign: :x, move_index: 0}, :other_player}
    assert {0, :x} == Players.get_current_move(players, Board.empty(3))
  end

  test "swap" do
    assert {:second, :first} == Players.swap({:first, :second})
  end

  test "show_current" do
    assert "Player x" == Players.show_current({ %PlayerStub{}, :other_player })
  end
end

