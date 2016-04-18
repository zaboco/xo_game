defmodule Board do
  @type status :: :in_progress | :tie | :win
  @type t :: Matrix.t

  @valid_indexes 0..8

  def empty(_size \\ size) do
    List.duplicate nil, size * size
  end

  def new(rows) do
    rows
    |> List.flatten
    |> Enum.map(fn
        :_ -> nil
        sign -> sign
      end)
  end

  def to_matrix(board, void_modifier \\ &(&1)) do
    board
    |> Enum.with_index
    |> Enum.map(&Cell.show &1, void_modifier)
    |> Enum.chunk(size)
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
    |> Enum.filter(fn {cell, i} -> cell_predicate.(cell) end)
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
      Matrix.rows(board) ++
      Matrix.columns(board) ++
      Tuple.to_list(Matrix.diagonals board)
    Enum.any? lines, &Cell.all_the_same?/1
  end

  defp full?(board) do
    Enum.all?(board, & not is_nil &1)
  end

  def size, do: 3
end

defmodule Cell do
  def show({cell, index}, void_modifier) do
    case cell do
      nil -> void_modifier.(index)
      sign -> sign
    end
  end

  def all_the_same?([nil | _]), do: false
  def all_the_same?([first | rest]) do
    Enum.all? rest, & &1 == first
  end
end
