defmodule GameState do
  alias GameState, as: State
  alias Player.Move
  import ShortMaps

  @opaque t :: %State{}
  defstruct board: Board.empty(3), players: []

  def initial(make_players \\ &Players.make/0) do
    %State{players: make_players.()}
  end

  def eval_next(state, get_current_move \\ &Players.get_current_move/2) do
    GameUI.log(:player_turn, [Players.show_current(state.players)])
    state
    |> update_board(get_current_move)
    |> eval_temporary_state
  end

  defp update_board(state, get_current_move) do
    Map.update! state, :board, fn board ->
      state.players
      |> get_current_move.(board)
      |> Move.apply_to(board)
      |> print_board
    end
  end

  @spec print_board(Board.t) :: no_return
  defp print_board(board) do
    GameUI.log(:board_updated)
    board
    |> Board.to_matrix(fn _ -> " " end)
    |> GameUI.print_matrix

    board
  end

  defp eval_temporary_state(~m(%State board players)a = state) do
    case Board.check_status(board) do
      :in_progress -> {:in_progress, spawp_players(state)}
      :win -> {:win, Players.show_current(players)}
      :tie -> {:tie}
    end
  end

  defp spawp_players(state) do
    Map.update! state, :players, &Players.swap/1
  end
end
