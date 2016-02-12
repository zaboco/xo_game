defmodule Game do
  alias String, as: S

  @type player :: {sign, player_type}
  @type player_type :: :human | :computer
  @type sign :: :x | :o

  @player_types [:human, :computer]

  def start do
    players = Enum.map [:x, :o], &Game.make_player/1
    Game.play_round GameState.initial(players)
  end

  def play_round(game_state) do
    raise "should not be called yet"
  end

  @spec make_player(sign) :: player
  def make_player(sign) do
    type = read_player_type_for sign
    {sign, type}
  end

  @spec read_player_type_for(sign) :: player_type
  defp read_player_type_for(sign) do
    prompt = "Choose type for #{sign} - [h]uman / [c]omputer: "
    type_initial = IO.gets(prompt) |> S.strip |> S.first |> S.to_atom
    case type_initial do
      :h -> :human
      :c -> :computer
      other ->
        IO.puts "Unknown type #{other}."
        read_player_type_for sign
    end
  end
end
