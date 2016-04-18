defmodule Board do
  def empty do
    List.duplicate nil, size * size
  end

  def new(rows) do
    List.flatten(rows)
  end

  def to_matrix(board, index_modifier \\ &(&1)) do
    board
    |> Enum.with_index
    |> Enum.map(fn
      {nil, i} -> index_modifier.(i)
      {sign, _i} -> sign
    end)
    |> rows
  end

  def put(board, index, sign) when is_integer(index) do
    case Enum.at(board, index) do
      nil ->
        List.replace_at(board, index, sign)
      _ ->
        board
    end
  end
  def put(_board, _index, _sign), do: :error

  def indexes_where(board, cell_predicate) do
    board
    |> Enum.with_index
    |> Enum.filter(fn {cell, _i} -> cell_predicate.(cell) end)
    |> Enum.map(& elem &1, 1)
  end

  def check_status(board) do
    cond do
      winner? board -> :win
      full? board -> :tie
      true -> :in_progress
    end
  end

  defp winner?(board) do
    lines =
      rows(board) ++
      columns(board) ++
      diagonals(board)

    Enum.any? lines, fn [first | rest] ->
      not is_nil(first) and Enum.all?(rest, & &1 == first)
    end
  end

  defp full?(board) do
    Enum.all?(board, & not is_nil &1)
  end

  defp rows(board) do
    Enum.chunk board, size
  end

  defp columns(board) do
    for i <- 0..size - 1 do
      board |> Enum.drop(i) |> Enum.take_every(size)
    end
  end

  defp diagonals(board) do
    first_diagonal = board |> Enum.take_every(size + 1)
    second_diagonal = board
      |> Stream.take_every(size - 1)
      |> Enum.slice(1, size)

    [first_diagonal, second_diagonal]
  end

  def size, do: 3
end
