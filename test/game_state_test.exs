defmodule GameStateTest do
  use ExUnit.Case
  alias GameState, as: State
  import Matrix.Sigils
  import GameUI.MockIO.Test

  test "initial" do
    make_players = fn -> :players end
    expected_state = %State{board: Board.empty(3), players: :players}
    assert State.initial(make_players) == expected_state
  end

  @players Players.with_types({"human", "computer"})
  @initial_state State.initial(fn -> @players end)

  test "eval_next for move that wins" do
    state = state_of board: ~m|_ x x : _ _ _ : _ _ _|
    expected = {:win, Players.show_current(@players)}
    assert State.eval_next(state, move_to(0)) == expected
  end

  test "eval_next for move that ends game as tie" do
    state = state_of board: ~m|
      _ o x
      o x o
      o x o|
    expected = {:tie}
    assert State.eval_next(state, move_to(0)) == expected
  end

  test "eval_next updates the state for neutral move" do
    state = state_of board: ~m|_ _ _ : _ _ _ : _ _ _|
    expected_state = state_of \
      board: ~m|x _ _ : _ _ _ : _ _ _|,
      players: Players.swap(@players)
    assert State.eval_next(state, move_to(0)) == {:in_progress, expected_state}
  end

  test "eval_next prints the board after the move is made" do
    State.eval_next(@initial_state, move_to(0))
    assert_output "board_updated\n"
    assert_output """
      +---+---+---+
      | x |   |   |
      +---+---+---+
      |   |   |   |
      +---+---+---+
      |   |   |   |
      +---+---+---+
      """
  end

  test "eval_next shows message for current player's turn" do
    State.eval_next(@initial_state, move_to(0))
    assert_output "player_turn: #{Players.show_current @players}\n"
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
