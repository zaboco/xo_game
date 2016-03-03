defmodule Doubles.FakeUI do
  @behaviour GameUI

  def init do
    :ets.new(__MODULE__, [:named_table])
    will_return read_index: ["1"]
  end

  def will_return(fixtures) do
    :ets.insert(__MODULE__, fixtures)
  end

  def read_player_type do
    :undefined
  end

  def log(message, param) do
    send self, {:log, [message, param]}
  end

  def read_index do
    [current | rest] = :ets.lookup_element(__MODULE__, :read_index, 2)
    will_return read_index: rest
    current
  end

  def print_matrix(matrix) do
    send self, {:print_matrix, matrix}
  end
end
