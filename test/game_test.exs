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

  defp with_inputs(inputs, cb) do
    expect IO, :gets, 1, seq inputs
    capture_io cb
    unload
  end
end
