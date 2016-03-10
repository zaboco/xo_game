defmodule Players do
  alias Player.{Human, Computer}

  @type t :: {Player.t, Player.t}

  @spec make((Player.sign -> String.t)) :: t
  def make(read_player_type \\ &GameUI.read_player_type/1) do
    [:x, :o]
    |> Enum.map(&make_one read_player_type.(&1), &1)
    |> List.to_tuple
  end

  @spec with_types({String.t, String.t}) :: t
  def with_types({first_type, second_type}) do
    {make_one(first_type, :x), make_one(second_type, :o)}
  end

  @spec make_one(String.t, Player.sign) :: t
  defp make_one(type, sign) do
    case String.first(type) do
      "h" -> %Human{sign: sign}
      _ -> %Computer{sign: sign}
    end
  end

  @spec get_current_move(t, Board.t) :: Player.move
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
