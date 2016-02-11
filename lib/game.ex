defmodule Game do
  @type player :: {sign, player_type}
  @type player_type :: :human | :computer
  @type sign :: :x | :o

  @player_types [:human, :computer]

  @spec make_player(sign) :: player
  def make_player(sign) do
    type_initial = IO.gets("Choose type for #{sign}: [h]uman / [c]omputer")
      |> String.strip |> String.first
    type = Enum.find @player_types, fn type ->
      type |> Atom.to_string |> String.starts_with?(type_initial)
    end
    {sign, type}
  end
end