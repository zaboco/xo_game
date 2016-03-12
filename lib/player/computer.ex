defmodule Player.Computer do
  use Player, :computer

  def get_move_index(_sign, board) do
    board
    |> Board.empty_cell_indexes
    |> Enum.random
  end
end
