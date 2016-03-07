defmodule GameUI.Console do
  @behaviour GameUI

  alias TableRex.Table

  def read_index do
    read_input("Choose an empty cell: ")
  end

  def read_player_type(sign) do
    read_input("Choose type for #{sign} - [h]uman / [c]omputer: ")
  end

  def log(:wrong_index, invalid_input) do
    IO.puts("Not a valid cell: #{invalid_input}")
  end

  @spec print_matrix([[any]]) :: no_return()
  def print_matrix(matrix) do
    matrix
    |> Table.new
    |> Table.render!(horizontal_style: :all)
    |> IO.write
  end

  defp read_input(prompt) do
    IO.gets(prompt) |> String.strip
  end
end
