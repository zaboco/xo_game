defmodule GameUI.MockIO.Test do
  defmacro with_inputs(inputs, do: block) do
    quote do
      old_inputs = Application.get_env :xo_game, :inputs, []
      Application.put_env :xo_game, :inputs, unquote(inputs)
      unquote(block)
      Application.put_env :xo_game, :inputs, old_inputs
    end
  end

  defmacro assert_output(output) do
    quote do
      assert_received {:output, unquote(output)}
    end
  end
end
