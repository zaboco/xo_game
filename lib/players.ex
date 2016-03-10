defmodule Players do
  alias Player.{Human, Computer}

  @type t :: {Player.t, Player.t}

  def make do
    [:x, :o]
    |> Enum.map(&make_one/1)
    |> List.to_tuple
  end

  defp make_one(sign) do
    type_initial = sign |> GameUI.read_player_type |> String.first
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
