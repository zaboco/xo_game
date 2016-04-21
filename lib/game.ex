defmodule Game do
  alias Player.{Computer, Human}

  def start() do
    [:x, :o]
    |> Enum.map(&make_player/1)
    |> GameState.initial
    |> Game.play_round
  end

  defp make_player(sign) do
    types_mapping = %{"c" => Computer, "h" => Human}
    type_name = GameUI.read_player_type(sign, Map.keys(types_mapping))
    type = types_mapping[type_name]
    Player.new(type, sign)
  end

  def play_round(game_state, eval_next \\ &GameState.eval_next/1) do
    case eval_next.(game_state) do
      {:win, winner_name} ->
        GameUI.log(:game_won, [winner_name])
        Game.stop
      {:tie} ->
        GameUI.log(:game_tie)
        Game.stop
      {:in_progress, next_state} ->
        Game.play_round(next_state)
    end
  end

  def stop do
    case GameUI.read_play_again do
      "n" -> GameUI.log(:goodbye)
      _ -> Game.start
    end
  end
end
