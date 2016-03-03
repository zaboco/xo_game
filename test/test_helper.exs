ExUnit.start(exclude: :test, include: :rewrite, timeout: 100)

Code.load_file("doubles/fake_ui.exs", "test")
Code.load_file("doubles/player_stub.exs", "test")

defmodule MeckUtils do
  import ExUnit.CaptureIO
  import :meck

  def with_inputs(inputs, cb) do
    expect IO, :gets, 1, seq inputs
    capture_io cb
    unload
  end
end
