defmodule MockIO do
  use MockIO.Behaviour

  def gets(_prompt) do
    case Application.get_env(:xo_game, :inputs) do
      [h | t] ->
        Application.put_env(:xo_game, :inputs, t)
        h
      [] ->
        ""
    end
  end

  def write(item) do
    send self, {:output, item}
  end
end
