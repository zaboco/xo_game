defmodule Spy do
  import ExUnit.Assertions

  def make_spy(name, arity \\ 0)
  def make_spy(name, 0), do: fn -> send_call name, [] end
  def make_spy(name, 1), do: &(send_call name, [&1])
  def make_spy(name, 2), do: &(send_call name, [&1, &2])
  def make_spy(name, 3), do: &(send_call name, [&1, &2, &3])
  def make_spy(_, _), do: raise "Arity above 3 not supported"

  defp send_call(name, args) do
    send self(), {:call, name, args}
  end

  def assert_called(name, args \\ []) do
    assert_received {:call, ^name, ^args}
  end
end
