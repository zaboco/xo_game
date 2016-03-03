defmodule Players.Human do
  defstruct [sign: :x, ui: nil]

  defimpl Player do
    def get_move(%{sign: sign, ui: ui}, board) do
      print_board(ui, board)
      {get_index(ui, board), sign}
    end

    defp print_board(ui, board) do
      board
      |> Board.to_matrix(& &1 + 1)
      |> ui.print_matrix
    end

    defp get_index(ui, board) do
      index_string = ui.read_index
      case parse_and_validate(index_string, board) do
        {:ok, index} ->
          index
        :error ->
          ui.log(:wrong_index, index_string)
          get_index(ui, board)
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
        {index, ""} -> {:ok, index - 1}
        :error -> :error
      end
    end

    defp validate_index(index, board) do
      case Board.empty_at?(board, index) do
        true -> {:ok, index}
        false -> :error
      end
    end

    def show(%{sign: sign}) do
      "#{sign}(human)"
    end
  end
end
