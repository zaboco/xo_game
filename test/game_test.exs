defmodule GameTest do
  use ExUnit.Case, async: false
  import MockIO.Test
  import Board.Sigils
  alias Player.{Human, Computer, Stub}

  setup do
    Stub.start_link()
    {:ok,
      stop_game_spy: Spy.make_spy(:stop_game_spy),
      play_round_spy: Spy.make_spy(:play_round_spy, 1),
      start_game_spy: Spy.make_spy(:start_game_spy)
    }
  end

  test "start plays the first round with the initial state", context do
    with_inputs ["h", "comp"] do
      expected_initial_state = %{
        board: Board.empty,
        players: [Player.new(Human, :x), Player.new(Computer, :o)]
      }
      Game.start(context[:play_round_spy])
      Spy.assert_called(:play_round_spy, [expected_initial_state])
    end
  end

  test "play_round ends game when the next state results in a win", context do
    state = %{
      board: ~b|_ x x : _ _ _ : _ _ _|,
      players: [player_moving_at(0, :x), :other_player]
    }
    Game.play_round(state, context[:stop_game_spy])
    assert_output "game_won: x(stub)\n"
    Spy.assert_called(:stop_game_spy)
  end

  test "play_round ends game when the next state results in a tie", context do
    state = %{
      board: ~b|
        _ o x
        o x o
        o x o|,
      players: [player_moving_at(0, :x), :other_player]
    }
    Game.play_round(state, context[:stop_game_spy])
    assert_output "game_tie\n"
    Spy.assert_called(:stop_game_spy)
  end

  test "play_round starts next round if the game is still in_progress", context do
    current_player = player_moving_at(0, :x)
    current_state = %{
      board: Board.empty,
      players: [current_player, :next_player]
    }
    expected_next_state = %{
      board: ~b|x _ _ : _ _ _ : _ _ _|,
      players: [:next_player, current_player]
    }
    Game.play_round(current_state, :any_stop_game_fn, context[:play_round_spy])
    Spy.assert_called(:play_round_spy, [expected_next_state])
  end

  test "stop starts a new game if the user wants to play again", context do
    with_inputs ["y"] do
      Game.stop(context[:start_game_spy])
      Spy.assert_called(:start_game_spy)
    end
  end

  test "stop exits if the users doesn't want another game" do
    with_inputs ["n"] do
      Game.stop
      assert_output "goodbye\n"
    end
  end

  defp player_moving_at(index, sign) do
    Stub.will_move(index)
    Player.new(Stub, sign)
  end
end
