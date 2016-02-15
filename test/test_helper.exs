ExUnit.start()

defmodule MeckUtils do
  import ExUnit.CaptureIO
  import :meck

  def with_inputs(inputs, cb) do
    expect IO, :gets, 1, seq inputs
    capture_io cb
    unload
  end
end
