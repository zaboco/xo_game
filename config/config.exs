use Mix.Config

config :xo_game,
  io: IO,
  messages: [
    move_index: "Choose an empty cell: ",
    player_type: &"Choose type for #{&1} - [h]uman / [c]omputer: ",
    wrong_index: &"Not a valid cell: #{&1}"
  ]

if Mix.env in [:test] do
  import_config "#{Mix.env}.exs"
end
