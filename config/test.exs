use Mix.Config

config :xo_game,
  io: GameUI.MockIO,
  messages: [
    wrong_index: &"wrong_index: #{&1}",
    player_turn: &"player_turn: #{&1}",
    board_updated: "board_updated",
    game_won: &"game_won: #{&1}",
    game_tie: "game_tie",
    goodbye: "goodbye"
  ]
