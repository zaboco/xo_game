use Mix.Config

config :xo_game,
  ui: GameUI.Console

if Mix.env in [:test] do
  import_config "#{Mix.env}.exs"
end
