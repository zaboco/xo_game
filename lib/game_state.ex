defmodule GameState do
  def initial players do
    {:in_progress, Board.empty, players}
  end
end
