defmodule Matrix.NestedMatrix do
  defstruct rows: []
  use Matrix.Behaviour

  def from_enum(enumerable, width) do
    %__MODULE__{rows: Enum.chunk(enumerable, width)}
  end

  def from_rows(rows) do
    %__MODULE__{rows: rows}
  end

  defimpl Matrix do
    def rows(%{rows: rows}) do
      rows
    end

    def columns(%{rows: rows}) do
      rows
      |> List.zip
      |> Enum.map(&Tuple.to_list &1)
    end

    def diagonals(%{rows: rows}) do
      rows
      |> Enum.with_index
      |> Enum.map(fn {row, i} -> items_at_distance row, i end)
      |> Enum.unzip
    end

    defp items_at_distance(list, i) do
      {Enum.at(list, i), Enum.at(list, -(i + 1))}
    end

    def map(%{rows: rows}, fun) do
      rows
      |> Enum.map(&Enum.map &1, fun)
      |> @for.from_rows
    end

    def all?(%{rows: rows}, fun) do
      rows
      |> List.flatten
      |> Enum.all?(fun)
    end
  end
end
