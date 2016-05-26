defmodule XoGame do
  def main(args) do
    parse_args(args)
    Game.start
  end

  def parse_args(args) do
    {opts, _, _} = OptionParser.parse(args)
    Application.put_env(:xo_game, :clear_screen, opts[:clear])
  end
end
