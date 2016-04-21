defmodule Game do
  alias Player.{Computer, Human}

  def start() do
    [:x, :o]
    |> Enum.map(&make_player/1)
    |> GameState.initial
    |> Game.play_round
  end

  defp make_player(sign) do
    sign
    |> GameUI.read_player_type
    |> player_type_from_string
    |> Player.new(sign)
  end

  defp player_type_from_string(type_name) do
    case String.first(type_name) do
      "c" -> Computer
      _ -> Human
    end
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
