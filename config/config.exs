use Mix.Config

config :xo_game,
  io: IO,
  messages: [
    move_index: "Choose an empty cell: ",
    player_type: &"Choose type for #{&1} - [h]uman / [c]omputer: ",
    play_again: "Play again? (Y/n) ",
    wrong_index: &"Not a valid cell: #{&1}",
    player_turn: &"\nIt is #{&1}'s turn:",
    board_updated: "The board is now:",
    game_won: &"Game over. #{&1} won!",
    game_tie: "Game over. It is a tie!",
    goodbye: "Too bad. Thanks for playing anyway!"
  ]

if Mix.env in [:test] do
  import_config "#{Mix.env}.exs"
end
