defmodule GameState do
  def initial players do
    {Board.empty, players}
  end

  def check_status(game_state) do
  end

  def apply_move({board, players}, {index, sign}) do
    new_board = board |> Board.fill_cell at: index, with: sign
    {new_board, players}
  end
end
