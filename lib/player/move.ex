defmodule Player.Move do
  @type t :: {Player.move_index, Player.sign}

  @spec new(Player.move_index, Player.sign) :: t
  def new(index, sign) do
    {index, sign}
  end

  def next_sign({_index, sign}), do: other_sign(sign)

  def index({index, _sign}), do: index

  defp other_sign(sign) do
    case sign do
      :x -> :o
      :o -> :x
    end
  end

  def apply_to({index, sign}, board) do
    Board.put(board, index, sign)
  end
end
