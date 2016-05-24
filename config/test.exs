use Mix.Config

config :xo_game,
  coloring_enabled: false,
  messages: [
    wrong_index: "wrong_index: :arg",
    wrong_type: "wrong_type: :arg",
    player_turn: "player_turn: :arg",
    board_updated: "board_updated",
    game_won: "game_won: :arg",
    game_tie: "game_tie",
    goodbye: "goodbye"
  ]
