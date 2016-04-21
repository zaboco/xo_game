defmodule Players do
  alias Player.{Human, Computer}

  def with_types({first_type, second_type}) do
    {make_one(first_type, :x), make_one(second_type, :o)}
  end

  defp make_one(type, sign) do
    case String.first(type) do
      "c" -> Player.new Computer, sign
      _ -> Player.new Human, sign
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
