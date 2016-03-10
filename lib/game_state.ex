defmodule GameState do
  alias GameState, as: State
  import ShortMaps

  @opaque t :: %State{}
  defstruct board: Board.empty(3), players: []

  def initial(make_players \\ &Players.make/0) do
    %State{players: make_players.()}
  end

  def evaluate_next(state, get_current_move \\ &Players.get_current_move/2) do
    updated_board = next_board(state, get_current_move)
    case Board.check_status(updated_board) do
      :in_progress ->
        updated_players = Players.swap(state.players)
        next_state = %State{board: updated_board, players: updated_players}
        {:in_progress, next_state}
      :win -> {:win, Players.show_current(state.players)}
      :tie -> {:tie}
    end
  end

  defp next_board(~m(%State board players)a, get_current_move) do
    players
    |> get_current_move.(board)
    |> apply_move(board)
  end

  defp apply_move({index, sign}, board) do
    Board.put(board, index, sign)
  end
end
