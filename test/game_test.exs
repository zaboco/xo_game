defmodule GameTest do
  use ExUnit.Case, async: false
  import ExUnit.CaptureIO
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

  test """
  play_round gets current player's move,
  applies it to the current state
  and calls end_round with the new state
  """ do
    initial_state = {:in_progress, :board, [{:x, :human}, nil]}
    expect Players, :get_move, [:board, :x], :move
    expect GameState, :apply_move, [initial_state, :move], :updated_state
    expect Game, :end_round, 1, nil
    Game.play_round initial_state
    assert called(Game, :end_round, [:updated_state])
  end

  test "if the game is still in_progress, end_round swaps players and starts the new round" do
    expect Game, :play_round, 1, nil
    Game.end_round {:in_progress, :board, [:current_player, :other_player]}
    assert called(Game, :play_round, [{:in_progress, :board, [:other_player, :current_player]}])
  end

  test "when player wins, end_round shows relevant message and ends game" do
    expect Game, :end_game, 0, nil
    output = capture_io fn ->
      Game.end_round {:win, :board, [:current_player, :other_player]}
    end
    assert output =~ ~r/current_player won/i
    assert called(Game, :end_game, [])
  end

  test "when it is a tie, end_round shows relevant message and ends game" do
    expect Game, :end_game, 0, nil
    output = capture_io fn ->
      Game.end_round {:tie, :board, :players}
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

  defp with_inputs(inputs, cb) do
    expect IO, :gets, 1, seq inputs
    capture_io cb
    unload
  end
end
