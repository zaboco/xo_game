defmodule XoGame.Mixfile do
  use Mix.Project

  def project do
    [app: :xo_game,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     consolidate_protocols: Mix.env != :test,
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test, "coveralls.html": :test],
     deps: deps]
  end

  def application do
    [applications: [:logger, :table_rex]]
  end

  defp deps do
    [
      {:table_rex, "~> 0.8.0"},
      {:excoveralls, "~> 0.4", only: :test},
      {:meck, "~> 0.8.4", only: :test},
      {:dialyze, "~> 0.2.0", only: :dev},
      {:mix_test_watch, "~> 0.2", only: :dev}
    ]
  end
end
