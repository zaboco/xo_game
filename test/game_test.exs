defmodule GameTest do
  use ExUnit.Case, async: false
  import ExUnit.CaptureIO
  import MeckUtils, only: [with_inputs: 2]
  import :meck

  setup do
    on_exit fn -> unload end
  end

  test "make_player gets its type from user input" do
    with_inputs ["h"], fn ->
      assert Game.make_player(:x) == {:x, :human}
    end

    with_inputs ["c"], fn ->
      assert Game.make_player(:x) == {:x, :computer}
    end
  end

  test "make_player also accepts whole words" do
    with_inputs ["human"], fn ->
      assert Game.make_player(:x) == {:x, :human}
    end
  end

  test "make_player asks for type until valid one is given" do
    with_inputs ["other", "h"], fn ->
      assert Game.make_player(:x) == {:x, :human}
    end
  end

  test "start makes both players and plays round with the initial state" do
    expect Game, :make_player, fn sign -> "player-#{sign}" end
    expect Game, :play_round, 1, nil
    Game.start
    assert called(Game, :play_round, [GameState.initial(["player-x", "player-o"])])
  end

  @player_x {:x, :human}
  test """
  play_round gets current player's move,
  applies it to the current state
  and calls end_round with the new state
  """ do
    initial_state = GameState.initial [@player_x, nil]
    move = {0, :x}
    updated_state = GameState.apply_move initial_state, move
    expect Players, :get_move, 2, move
    expect Game, :end_round, 1, nil
    capture_io fn -> Game.play_round initial_state end
    assert called(Game, :end_round, [updated_state])
  end

  test "if the game is still in_progress, end_round swaps players and starts the new round" do
    expect GameState, :check_status, [:board], :in_progress
    expect Board, :print, [:board], nil
    expect Game, :play_round, 1, nil
    capture_io fn -> Game.end_round {:board, [:current_player, :other_player]} end
    assert called(Game, :play_round, [{:board, [:other_player, :current_player]}])
  end

  test "when player wins, end_round shows relevant message and ends game" do
    expect GameState, :check_status, [:board], :win
    expect Board, :print, [:board], nil
    expect Game, :end_game, 0, nil
    output = capture_io fn ->
      Game.end_round {:board, [{:x, :human}, :other_player]}
    end
    assert output =~ ~r/x\(human\) won/i
    assert called(Game, :end_game, [])
  end

  test "when it is a tie, end_round shows relevant message and ends game" do
    expect GameState, :check_status, [:board], :tie
    expect Board, :print, [:board], nil
    expect Game, :end_game, 0, nil
    output = capture_io fn ->
      Game.end_round {:board, :players}
    end
    assert output =~ ~r/it is a tie/i
    assert called(Game, :end_game, [])
  end

  test "end_game starts a new game if the user chooses to" do
    assert_game_start_called = fn ->
      expect Game, :start, 0, nil
      Game.end_game
      assert called(Game, :start, [])
    end
    with_inputs ["y"], assert_game_start_called
    with_inputs [""], assert_game_start_called
  end

  test "end_game does not starts a new game if the user chooses to" do
    assert_game_start_not_called = fn ->
      expect Game, :start, 0, nil
      output = capture_io fn -> Game.end_game end
      assert output =~ ~r/thanks for playing/i
      assert !called(Game, :start, [])
    end
    with_inputs ["n"], assert_game_start_not_called
    with_inputs ["x"], assert_game_start_not_called
  end
end
