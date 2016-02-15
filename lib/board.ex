defmodule Board do
  @size 3

  def empty, do: ~b|_ _ _ : _ _ _ : _ _ _|

  def is_cell_empty? board, cell_index do
    board |> List.flatten |> Enum.any?(&(&1 == cell_index))
  end

  def fill_cell(board, at: index, with: sign) do
    new_board = Enum.map board, fn row ->
      replace_in row, index, sign
    end
    case new_board do
      ^board -> {:error, "Invalid cell: #{index}"}
      valid_board -> {:ok, valid_board}
    end
  end

  defp replace_in list, old, new do
    Enum.map list, fn
      ^old -> new
      other -> other
    end
  end

  def sigil_b(term, []) do
    matrix_from_string term, ":"
  end

  def sigil_B(term, []) do
    matrix_from_string term, "\n"
  end

  defp matrix_from_string string, separator do
    string
      |> String.strip
      |> String.split(separator)
      |> Enum.map(&to_atoms/1)
      |> fill_matrix_with_indexes(@size)
  end

  def fill_matrix_with_indexes(matrix, size) do
    matrix
      |> Enum.with_index
      |> Enum.map(fn {row, i} ->
        fill_list_with_indexes row, size * i
      end)
  end

  def fill_list_with_indexes(list, offset \\ 0) do
    list
      |> Enum.with_index(offset)
      |> Enum.map(fn
        {:_, i} -> i
        {other, _i} -> other
      end)
  end

  defp to_atoms(string) do
    String.split(string) |> Enum.map(&String.to_atom/1)
  end
end
