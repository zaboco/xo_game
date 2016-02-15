defmodule Players.Human do
  alias TableRex.Table

  def read_move board, sign do
    print_board board
    cell_index = IO.gets("Choose an empty cell: ")
      |> String.strip
      |> String.to_integer
    cond do
      !Board.is_cell_empty?(board, cell_index) -> read_move board, sign
      true -> {cell_index, sign}
    end
  end

  defp print_board board do
    Table.new(board) |> Table.render!(horizontal_style: :all) |> IO.write
  end
end
