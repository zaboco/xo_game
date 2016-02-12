defmodule GameState do
  def initial players do
    {:in_progress, Board.empty, players}
  end

  def apply_move(game_state, move) do
  end
end
