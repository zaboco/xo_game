defmodule GameUI do
  alias TableRex.Table

  def read_index() do
    :move_index |> format_message |> io.gets
  end

  def read_player_type(sign) do
    :player_type |> format_message([sign]) |> io.gets
  end

  def print_matrix(matrix) do
    matrix |> format_matrix |> io.write
  end

  def log(message_type, arg) do
    message_type |> format_message([arg]) |> io.puts
  end

  defp format_message(code, args \\ nil) do
    message = Application.get_env(:xo_game, :messages)[code]
    case args do
      nil -> message
      args -> apply(message, args)
    end
  end

  defp format_matrix(matrix) do
    matrix
    |> Table.new
    |> Table.render!(horizontal_style: :all)
  end

  defp io, do: Application.get_env(:xo_game, :io)
end
