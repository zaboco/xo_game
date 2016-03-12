defmodule Game do
  def start(init_state \\ &GameState.initial/0) do
    Game.play_round(init_state.())
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
