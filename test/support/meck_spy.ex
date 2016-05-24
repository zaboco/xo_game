defmodule MeckSpy do
  defmacro verify_call(module, fun, arg, do: block) do
    quote do
      [module, fun, arg] = unquote([module, fun, arg])
      :meck.expect module, fun, fn
        ^arg -> nil
        other -> :meck.passthrough([other])
      end
      unquote(block)
      assert :meck.called module, fun, [arg]
      :meck.unload
    end
  end

  defmacro verify_call(module, fun, do: block) do
    quote do
      [module, fun] = unquote([module, fun])
      :meck.expect module, fun, fn -> nil end
      unquote(block)
      assert :meck.called module, fun, []
      :meck.unload
    end
  end
end
