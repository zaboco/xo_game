defmodule GameTest do
  use ExUnit.Case, async: false
  import MockIO.Test
  import Board.Sigils
  import MeckSpy, only: [verify_call: 4, verify_call: 3]
  alias Player.{Human, Computer, Stub}

  setup do
    Stub.start_link()
    :ok
  end

  test "start plays the first round with the initial state" do
    with_inputs ["h", "comp"] do
      expected_initial_state = %{
        board: Board.empty,
        players: [Player.new(Human, :x), Player.new(Computer, :o)]
      }
      verify_call Game, :play_round, expected_initial_state do
        Game.start()
      end
    end
  end

  test "play_round ends game when the next state results in a win" do
    state = %{
      board: ~b|_ x x : _ _ _ : _ _ _|,
      players: [player_moving_at(0, :x), :other_player]
    }
    verify_call Game, :stop do
      Game.play_round(state)
      assert_output "game_won: x(stub)\n"
    end
  end

  test "play_round ends game when the next state results in a tie" do
    state = %{
      board: ~b|
        _ o x
        o x o
        o x o|,
      players: [player_moving_at(0, :x), :other_player]
    }
    verify_call Game, :stop do
      Game.play_round(state)
      assert_output "game_tie\n"
    end
  end

  test "play_round starts next round if the game is still in_progress" do
    current_player = player_moving_at(0, :x)
    current_state = %{
      board: Board.empty,
      players: [current_player, :next_player]
    }
    expected_next_state = %{
      board: ~b|x _ _ : _ _ _ : _ _ _|,
      players: [:next_player, current_player]
    }
    verify_call Game, :play_round, expected_next_state do
      Game.play_round(current_state)
    end
  end

  test "stop starts a new game if the user wants to play again" do
    verify_call Game, :start do
      with_inputs ["y"] do
        Game.stop
      end
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
