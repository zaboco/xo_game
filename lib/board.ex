defmodule Board do
  alias Matrix.LinearMatrix, as: Matrix

  @type status :: :in_progress | :tie | :win
  @type t :: Matrix.t

  def empty(size) do
    0..(size * size - 1)
    |> Enum.map(&Cell.empty/1)
    |> Matrix.from_enum
  end

  def new(rows) do
    rows
    |> List.flatten
    |> Enum.with_index
    |> Enum.map(fn
        {:_, index} -> index
        {sign, _index} -> sign
      end)
    |> Matrix.from_enum
  end

  def to_matrix(board, void_modifier \\ &(&1)) do
    board
    |> Matrix.map(&Cell.show &1, void_modifier)
    |> Matrix.rows
  end

  def put(board, index, sign) do
    board
    |> Matrix.map(&Cell.fill &1, if_at: index, with: sign)
  end

  def empty_at?(board, index) when index >= 0 do
    board
    |> Enum.at(index)
    |> Cell.empty?
  end
  def empty_at?(_board, _index), do: false

  def empty_cell_indexes(board) do
    Enum.filter(board, &is_integer/1)
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
    board
    |> Enum.all?(&Cell.filled?/1)
  end
end

defmodule Cell do
  @void :_
  @signs [:x, :o]

  def empty(index) do
    index
  end

  def show(cell, void_modifier) do
    case cell do
      index when is_integer(index) -> void_modifier.(index)
      sign -> sign
    end
  end

  def fill(cell, if_at: index, with: sign) when sign in @signs do
    case cell do
      ^index -> sign
      existing_cell -> existing_cell
    end
  end

  def filled?(cell) when is_integer(cell), do: false
  def filled?(_), do: true

  def empty?(cell), do: !filled?(cell)

  def all_the_same?([first | rest]) do
    Enum.all? rest, & &1 == first
  end
end
