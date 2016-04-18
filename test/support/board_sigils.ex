defmodule Board.Sigils do
  @separators [":", "\n"]

  def sigil_b(term, []) do
    term
    |> String.strip
    |> String.split(@separators)
    |> Enum.map(&to_atoms/1)
    |> Board.new
  end

  defp to_atoms(string) do
    string
    |> String.split
    |> Enum.map(&String.to_atom/1)
  end
end
