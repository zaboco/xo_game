defmodule Matrix.LinearMatrix do
  defstruct items: [], width: 0
  use Matrix.Behaviour

  def from_enum(enumerable, width) do
    %__MODULE__{items: Enum.to_list(enumerable), width: width}
  end

  def from_rows(rows) do
    width = rows |> hd |> length
    %__MODULE__{items: List.flatten(rows), width: width}
  end

  defimpl Matrix do
    def rows(%{items: items, width: width}) do
      Enum.chunk items, width
    end

    def columns(%{items: items, width: width}) do
      for i <- 0..width - 1 do
        items |> Enum.drop(i) |> Enum.take_every(width)
      end
    end

    def diagonals(%{items: items, width: width}) do
      first_diagonal = items |> Enum.take_every(width + 1)
      second_diagonal = items
        |> Stream.take_every(width - 1)
        |> Enum.slice(1, width)
      {first_diagonal, second_diagonal}
    end

    def map(matrix, fun) do
      Map.update! matrix, :items, &Enum.map(&1, fun)
    end
  end

  defimpl Enumerable do
    def reduce(%{items: items}, acc, reducer) do
      Enumerable.reduce(items, acc, reducer)
    end

    def member?(_, _) do
    end

    def count(_) do
    end
  end
end
