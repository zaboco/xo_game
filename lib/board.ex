defmodule Board do
  alias Matrix.LinearMatrix

  def empty(size) do
    0..(size * size - 1)
    |> Enum.map(&Cell.empty/1)
    |> LinearMatrix.from_enum
  end

  def new(rows) do
    rows
    |> List.flatten
    |> Enum.with_index
    |> LinearMatrix.from_enum
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


  # TODO: delete these
  def sigil_b(_term, []) do
  end

  def sigil_B(_term, []) do
  end
end

defmodule Cell do
  @void :_
  @signs [:x, :o]

  def empty(index) do
    {@void, index}
  end

  def show(cell, void_modifier \\ &(&1)) do
    case cell do
      {@void, index} -> void_modifier.(index)
      {sign, _index} -> sign
    end
  end

  def fill(cell, if_at: index, with: sign) when sign in @signs do
    case cell do
      {@void, ^index} -> {sign, index}
      existing_cell -> existing_cell
    end
  end

  def filled?({@void, _i}), do: false
  def filled?(_), do: true

  def empty?(cell), do: !filled?(cell)

  def all_the_same?([first | rest]) do
    Enum.all? rest, &same_sign_as?(&1, first)
  end

  defp same_sign_as?({sign, _i}, {sign, _j}), do: sign != @void
  defp same_sign_as?(_, _), do: false
end
