defmodule Board do
  def empty, do: ~b|_ _ _ : _ _ _ : _ _ _|

  def sigil_b(term, []) do
    String.split(term, ":") |> Enum.map(&to_atoms/1)
  end

  def sigil_B(term, []) do
    term
      |> String.strip
      |> String.split("\n")
      |> Enum.map(&to_atoms/1)
  end

  defp to_atoms(string) do
    String.split(string) |> Enum.map(&String.to_atom/1)
  end
end
