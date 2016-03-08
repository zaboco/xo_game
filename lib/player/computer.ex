defmodule Player.Computer do
  use Player, :computer

  def get_move_index(_sign) do
    1
  end
end
