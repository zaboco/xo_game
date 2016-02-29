defmodule PlayerStub do
  defstruct sign: :x, move_index: 0

  defimpl Player do
    def get_move(%{move_index: move_index, sign: sign}, _board) do
      {move_index, sign}
    end

    def show(player), do: "Player #{player.sign}"
  end
end


defmodule PlayersTest do
  use ExUnit.Case
  alias Players.{Human, Computer}

  @moduletag :rewrite

  test "make reads type for each sign and creates players of the given type" do
    type_reader = fn :x -> "h"; :o -> "computer" end
    expected_players = { %Human{sign: :x}, %Computer{sign: :o} }
    assert expected_players == Players.make(type_reader)
  end

  test "get_current_move gets the move from the current player" do
    players = { %PlayerStub{sign: :x, move_index: 0}, :other_player }
    assert {0, :x} == Players.get_current_move(players, Board.empty(3))
  end

  test "swap" do
    assert {:second, :first} == Players.swap({:first, :second})
  end

  test "show_current" do
    assert "Player x" == Players.show_current({ %PlayerStub{}, :other_player })
  end
end

