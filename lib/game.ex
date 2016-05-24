defmodule Game do
  alias Player.{Computer, Human}

  def start() do
    players = Enum.map([:x, :o], &make_player/1)
    Game.play_round(%{players: players, board: Board.empty})
  end

  defp make_player(sign) do
    types_mapping = %{"c" => Computer, "h" => Human}
    type_name = GameUI.read_player_type(sign, Map.keys(types_mapping))
    type = types_mapping[type_name]
    Player.new(type, sign)
  end

  def play_round(%{board: board, players: [current_player, _] = players}) do
    move = Player.get_move(current_player, board)
    case eval_move(move, board) do
      {:win, _board} ->
        GameUI.log(:game_won, Player.show(current_player))
        Game.stop()
      {:tie, _board} ->
        GameUI.log(:game_tie)
        Game.stop()
      {:in_progress, board} ->
        next_state = %{board: board, players: swap_players(players)}
        Game.play_round(next_state)
    end
  end

  defp eval_move({index, sign}, board) do
    new_board = Board.put(board, index, sign)
    {Board.check_status(new_board), new_board}
  end

  defp swap_players([current, next]) do
    [next, current]
  end

  def stop() do
    case GameUI.read_play_again do
      "n" -> GameUI.log(:goodbye)
      _ -> Game.start()
    end
  end
end
