defmodule MeckSpy do
  import ExUnit.Assertions

  def verify_call(module, fun, arg, block_fn) do
    :meck.expect module, fun, fn
      ^arg -> nil
      other -> :meck.passthrough([other])
    end
    block_fn.()
    assert :meck.called module, fun, [arg]
    :meck.unload
  end

  def verify_call(module, fun, block_fn) do
    :meck.expect module, fun, fn -> nil end
    block_fn.()
    assert :meck.called module, fun, []
    :meck.unload
  end
end
