defmodule Players do
  alias Players.{Human, Computer}

  def make do
    [:x, :o]
    |> Enum.map(&make_one/1)
    |> List.to_tuple
  end

  defp make_one(sign) do
    type_initial = sign |> GameUI.impl.read_player_type |> String.first
    case type_initial do
      "h" -> %Human{sign: sign}
      "c" -> %Computer{sign: sign}
    end
  end

  def get_current_move({current, _other}, board) do
    Player.get_move current, board
  end

  def swap({current, next}) do
    {next, current}
  end

  def show_current({current, _other}) do
    Player.show current
  end
end

defprotocol Player do
  @type move :: {number, atom}

  @spec get_move(t, Matrix.t) :: move
  def get_move(player, board)

  @spec show(t) :: String.t
  def show(player)
end
