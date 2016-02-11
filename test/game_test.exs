defmodule GameTest do
  use ExUnit.Case, async: false
  import Mock

  test "make_player gets its type from user input" do
    with_input "h", fn ->
      assert Game.make_player(:x) == {:x, :human}
    end
  end

  defp with_input(input, cb) do
    with_mock IO, gets: fn(_) -> input end do
      cb.()
    end
  end
end
