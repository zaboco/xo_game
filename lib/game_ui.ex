defmodule GameUI do
  alias TableRex.Table

  def read_index() do
    ask(:move_index)
  end

  def read_player_type(sign, valid_types) do
    type_name = ask(:player_type, sign) |> String.downcase
    if (type_initial = String.first(type_name)) in valid_types do
      type_initial
    else
      log(:wrong_type, type_name)
      read_player_type(sign, valid_types)
    end
  end

  def read_play_again() do
    ask(:play_again) |> String.strip |> String.downcase
  end

  defp ask(question_type, arg \\ nil) do
    question_type |> format_message(arg) |> IO.gets
  end

  def print_board(board) do
    board
    |> Board.to_matrix(&index_to_ui/1)
    |> format_matrix
    |> IO.write
  end

  def log_player_move({index, _sign}, board) do
    clear_screen()
    log(:player_has_moved, index_to_ui(index))
    print_board(board)
  end

  defp index_to_ui(index), do: index + 1

  def log(message_type, arg \\ nil) do
    message_type |> format_message(arg) |> IO.puts
  end

  def clear_screen do
    if Application.get_env(:xo_game, :clear_screen) do
      IO.write(IO.ANSI.clear <> IO.ANSI.home)
    end
  end

  defp format_message(code, arg) do
    message = Application.get_env(:xo_game, :messages)[code]
    case arg do
      nil -> message
      _ -> String.replace(message, ":arg", to_string(arg))
    end
  end

  defp format_matrix(matrix) do
    matrix
    |> Table.new
    |> Table.render!(horizontal_style: :all)
    |> add_colors
  end

  defp add_colors(matrix_string) do
    matrix_string
    |> String.replace(~r/(\d)/, paint("\\1", :red))
    |> String.replace(~r/(x)/, paint("\\1", :blue))
    |> String.replace(~r/(o)/, paint("\\1", :yellow))
  end

  defp paint(string, color) do
    if Application.get_env(:xo_game, :coloring_enabled) do
      apply(IO.ANSI, color, []) <> string <> IO.ANSI.reset
    else
      string
    end
  end
end
