defmodule Player.Human do
  def name, do: "human"

  def get_move_index(_sign, board) do
    print_board(board)
    get_index(board)
  end

  defp print_board(board) do
    board
    |> Board.to_matrix(& &1 + 1)
    |> GameUI.print_matrix
  end

  defp get_index(board) do
    index_string = GameUI.read_index
    case parse_and_validate(index_string, board) do
      {:ok, index} ->
        GameUI.clear_screen
        index
      :error ->
        GameUI.log(:wrong_index, [index_string])
        get_index(board)
    end
  end

  defp parse_and_validate(index_string, board) do
    with \
      {:ok, index} <- parse_index(index_string),
      {:ok, valid_index} <- validate_index(index, board),
    do: {:ok, valid_index}
  end

  defp parse_index(index_string) do
    case Integer.parse(index_string) do
      {index, _rest} -> {:ok, index - 1}
      :error -> :error
    end
  end

  defp validate_index(index, board) do
    empty_cell_indexes = Board.indexes_where(board, &is_nil/1)
    case index in empty_cell_indexes do
      true -> {:ok, index}
      false -> :error
    end
  end
end
