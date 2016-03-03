defmodule PlayerStub do
  defstruct sign: :x, move_index: 0

  defimpl Player do
    def get_move(%{move_index: move_index, sign: sign}, _board) do
      {move_index, sign}
    end

    def show(player), do: "Player #{player.sign}"
  end
end
