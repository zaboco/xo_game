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

  def play_round({board, [player, _other] = players} = game_state) do
    IO.puts "\nIt is #{Players.show_current players}'s turn:"
    move = Players.get_move board, player
    game_state
      |> GameState.apply_move(move)
      |> Game.end_round
  end

  def end_round({board, players}) do
    IO.puts "The board is now:"
    Board.print board
    case GameState.check_status(board) do
      :in_progress ->
        Game.play_round({board, Players.swap(players)})
      :win ->
        IO.puts "Game over. #{Players.show_current players} won!"
        Game.end_game
      :tie ->
        IO.puts "Game over. It is a tie!"
        Game.end_game
    end
  end

  def end_game do
    answer = IO.gets("Play again? (Y/n)") |> S.strip |> S.downcase
    case answer do
      ok when ok in ["y", ""] -> Game.start
      _ -> IO.puts "Too bad. Thanks for playing anyway!"
    end
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
