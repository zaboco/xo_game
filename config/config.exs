use Mix.Config

config :xo_game,
  io: IO,
  coloring_enabled: true,
  messages: [
    move_index: "Choose an empty cell: ",
    player_type: "Choose type for :arg - [H]uman / [c]omputer: ",
    play_again: "Play again? (Y/n) ",
    wrong_index: "Not a valid cell: :arg",
    wrong_type: "Not a valid type: :arg",
    player_turn: "\nIt is :arg's turn:",
    board_updated: "The board is now:",
    game_won: "Game over. :arg won!",
    game_tie: "Game over. It is a tie!",
    goodbye: "Too bad. Thanks for playing anyway!"
  ]

if Mix.env in [:test] do
  import_config "#{Mix.env}.exs"
end
