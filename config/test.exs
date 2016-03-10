use Mix.Config

config :xo_game,
  io: GameUI.MockIO,
  messages: [
    wrong_index: &"wrong_index: #{&1}"
  ]
