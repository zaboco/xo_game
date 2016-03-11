defmodule GameUI do
  alias TableRex.Table

  def read_index() do
    ask(:move_index)
  end

  def read_player_type(sign) do
    ask(:player_type, [sign])
  end

  def read_play_again() do
    ask(:play_again) |> String.strip |> String.downcase
  end

  defp ask(question_type, args \\ []) do
    question_type |> format_message(args) |> io.gets
  end

  def print_matrix(matrix) do
    matrix |> format_matrix |> io.write
  end

  def log(message_type, args \\ []) do
    message_type |> format_message(args) |> io.puts
  end

  defp format_message(code, args) do
    message = Application.get_env(:xo_game, :messages)[code]
    case args do
      [] -> message
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
