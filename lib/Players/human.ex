defmodule Players.Human do
  defstruct [:sign]

  def read_move board, sign do
    Board.print_with_indexes board
    {read_index_in(board), sign}
  end

  defp read_index_in board do
    input = IO.gets("Choose an empty cell: ") |> String.strip
    case index_if_valid input, in: board do
      nil ->
        IO.puts "Cell #{input} is not valid!"
        read_index_in board
      index -> index
    end
  end

  defp index_if_valid index_as_string, in: board do
    case Integer.parse index_as_string do
      {index, ""} -> if Board.is_cell_empty?(board, index), do: index
      :error -> nil
    end
  end
end
