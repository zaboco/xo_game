use Mix.Config

config :xo_game,
  coloring_enabled: true,
  messages: [
    move_index: "Choose an empty cell: ",
    player_type: "Choose type for :arg - [h]uman / [c]omputer: ",
    play_again: "Play again? (Y/n) ",
    wrong_index: "Not a valid cell: :arg",
    wrong_type: "Not a valid type: :arg",
    player_turn: "\n:arg to move...",
    player_has_moved: "\nPlayer moved at :arg:",
    board_updated: "The board is now:",
    game_won: "Game over. :arg won!",
    game_tie: "Game over. It is a tie!",
    goodbye: "Too bad. Thanks for playing anyway!"
  ]

if Mix.env in [:test] do
  import_config "#{Mix.env}.exs"
end
