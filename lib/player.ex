defmodule Player do
  def new(type, sign), do: {type, sign}

  def show({type, sign}) do
    "#{sign}(#{type.name})"
  end

  def get_move({type, sign}, board) do
    {type.get_move_index(sign, board), sign}
  end
end
