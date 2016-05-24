defmodule GameTest do
  use ExUnit.Case, async: false
  import ExUnit.CaptureIO
  import Board.Sigils
  import MeckSpy, only: [verify_call: 4, verify_call: 3]
  alias Player.{Human, Computer, Stub}

  setup do
    Stub.start_link()
    :ok
  end

  test "start plays the first round with the initial state" do
    expected_initial_state = %{
      board: Board.empty,
      players: [Player.new(Human, :x), Player.new(Computer, :o)]
    }
    verify_call Game, :play_round, expected_initial_state, fn ->
      output = capture_io [input: "h\ncomp", capture_prompt: false], fn ->
        Game.start()
      end
      assert output == """
        +---+---+---+
        | 1 | 2 | 3 |
        +---+---+---+
        | 4 | 5 | 6 |
        +---+---+---+
        | 7 | 8 | 9 |
        +---+---+---+
        """
    end
  end

  test "play_round ends game when the next state results in a win" do
    state = %{
      board: ~b|_ x x : _ _ _ : _ _ _|,
      players: [player_moving_at(0, :x), :other_player]
    }
    verify_call Game, :stop, fn ->
      output = capture_io fn -> Game.play_round(state) end
      assert String.contains? output, "game_won: x(stub)\n"
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
    verify_call Game, :stop, fn ->
      output = capture_io fn -> Game.play_round(state) end
      assert String.contains? output, "game_tie\n"
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
    verify_call Game, :play_round, expected_next_state, fn ->
      output = capture_io fn -> Game.play_round(current_state) end
      assert output == """
        player_turn: x(stub)
        player_has_moved: 1
        +---+---+---+
        | x | 2 | 3 |
        +---+---+---+
        | 4 | 5 | 6 |
        +---+---+---+
        | 7 | 8 | 9 |
        +---+---+---+
        """
    end
  end

  test "stop starts a new game if the user wants to play again" do
    verify_call Game, :start, fn ->
      capture_io "y", fn ->
        Game.stop()
      end
    end
  end

  test "stop exits if the users doesn't want another game" do
    output = capture_io [input: "n", capture_prompt: false], fn ->
      Game.stop
    end
    assert output == "goodbye\n"
  end

  defp player_moving_at(index, sign) do
    Stub.will_move(index)
    Player.new(Stub, sign)
  end
end
