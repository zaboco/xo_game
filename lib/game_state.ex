defmodule GameState do
  def initial players do
    {Board.empty, players}
  end

  def check_status board do
    cond do
      is_win board -> :win
    end
  end

  defp is_win board do
    [&rows/1, &columns/1, &diagonals/1]
      |> Enum.flat_map(fn selector -> selector.(board) end)
      |> Enum.any?(&same_items?/1)
  end

  defp rows matrix do
    matrix
  end

  defp columns matrix do
    matrix |> List.zip |> Enum.map(&Tuple.to_list/1)
  end

  def diagonals matrix do
    matrix
      |> Enum.with_index
      |> Enum.map(fn {row, i} ->
        { Enum.at(row, i), Enum.at(row, -(i+1)) }
      end)
      |> Enum.unzip
      |> Tuple.to_list
  end

  defp same_items? list do
    case list do
      [] -> true
      [x | xs] -> Enum.all? xs, &(&1 == x)
    end
  end

  def apply_move({board, players}, {index, sign}) do
    new_board = board |> Board.fill_cell(at: index, with: sign)
    {new_board, players}
  end
end
