defmodule GameUI.Mock do
  @behaviour GameUI

  def will_return(fixtures) do
    init_cache
    :ets.insert(__MODULE__, fixtures)
  end

  defp init_cache do
    if :ets.info(__MODULE__) == :undefined do
       :ets.new(__MODULE__, [:named_table])
    end
  end

  def read_player_type(_) do
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
