defmodule Player.Stub do
  use Player, :stub

  def get_move_index(_sign, _board) do
    move_index
  end

  def move_index do
    3
  end
end
