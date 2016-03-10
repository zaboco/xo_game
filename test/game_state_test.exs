defmodule GameStateTest do
  use ExUnit.Case
  alias GameState, as: State
  import Matrix.Sigils

  @moduletag :rewrite

  test "initial" do
    make_players = fn -> :players end
    expected_state = %State{board: Board.empty(3), players: :players}
    assert State.initial(make_players) == expected_state
  end

  @players Players.with_types({"human", "computer"})

  test "evaluate_next for move that wins" do
    state = state_of board: ~m|_ x x : _ _ _ : _ _ _|
    expected = {:win, Players.show_current(@players)}
    assert State.evaluate_next(state, move_to(0)) == expected
  end

  test "evaluate_next for move that ends game as tie" do
    state = state_of board: ~m|
      _ o x
      o x o
      o x o|
    expected = {:tie}
    assert State.evaluate_next(state, move_to(0)) == expected
  end

  test "evaluate_next updates the state for neutral move" do
    state = state_of board: ~m|_ _ _ : _ _ _ : _ _ _|
    expected_state = state_of \
      board: ~m|x _ _ : _ _ _ : _ _ _|,
      players: Players.swap(@players)
    assert State.evaluate_next(state, move_to(0)) == {:in_progress, expected_state}
  end

  defp state_of(board: matrix) do
    state_of board: matrix, players: @players
  end
  defp state_of(board: matrix, players: players) do
    %State{board: Board.new(matrix), players: players}
  end

  defp move_to(index) do
    fn(_players, _board) -> {index, :x} end
  end
end
