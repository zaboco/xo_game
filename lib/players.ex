defmodule Players do
  alias Players.{Human, Computer}

  def make(type_reader) do
    [:x, :o]
    |> Enum.map(fn sign -> make_one type_reader.(sign), sign end)
    |> List.to_tuple
  end

  defp make_one(type, sign) do
    case String.first(type) do
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
  @spec get_move(t, Matrix.t) :: number
  def get_move(player, board)

  @spec show(t) :: String.t
  def show(player)
end
