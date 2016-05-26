defmodule Player.Stub do
  def name, do: "stub"

  def start_link() do
    Agent.start_link(fn -> 0 end, name: __MODULE__)
  end

  def will_move(index) do
    Agent.update(__MODULE__, fn _ -> index end)
  end

  def get_move_index(_sign, _board) do
    Agent.get(__MODULE__, &(&1))
  end
end
