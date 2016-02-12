defmodule GameTest do
  use ExUnit.Case, async: false
  import ExUnit.CaptureIO
  import :meck

  test "make_player gets its type from user input" do
    with_inputs ["h"], fn ->
      assert Game.make_player(:x) == {:x, :human}
    end

    with_inputs ["c"], fn ->
      assert Game.make_player(:x) == {:x, :computer}
    end
  end

  test "make_player also accepts whole words" do
    with_inputs ["human"], fn ->
      assert Game.make_player(:x) == {:x, :human}
    end
  end

  test "make_player asks for type until valid one is given" do
    with_inputs ["other", "h"], fn ->
      assert Game.make_player(:x) == {:x, :human}
    end
  end

  defp with_inputs(inputs, cb) do
    expect IO, :gets, [:_], seq inputs
    capture_io cb
    unload
  end
end
