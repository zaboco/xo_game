defmodule Matrix.LinearMatrix do
  def from_enum(enumerable) do
    Enum.to_list(enumerable)
  end

  def rows(items) do
    Enum.chunk items, width
  end

  def columns(items) do
    for i <- 0..width - 1 do
      items |> Enum.drop(i) |> Enum.take_every(width)
    end
  end

  def diagonals(items) do
    first_diagonal = items |> Enum.take_every(width + 1)
    second_diagonal = items
      |> Stream.take_every(width - 1)
      |> Enum.slice(1, width)
    {first_diagonal, second_diagonal}
  end

  def map(items, fun) do
    Enum.map(items, fun)
  end

  defp width do
    3
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
