defmodule GameTest do
  use ExUnit.Case, async: false
  import MockIO.Test
  alias Player.{Human, Computer}

  defmacro verify_call(call, do: block) do
    {fun, _, args} = call
    {:., _, [module, fun_name]} = fun
    quote do
      args = unquote([module, fun_name, args])
      apply(:meck, :expect, args ++ [nil])
      unquote(block)
      assert apply(:meck, :called, args)
      :meck.unload
    end
  end

  test "start plays the first round with the initial state" do
    with_inputs ["h", "comp"] do
      expected_initial_state = %GameState{
        players: [Player.new(Human, :x), Player.new(Computer, :o)]
      }
      verify_call Game.play_round(expected_initial_state) do
        Game.start()
      end
    end
  end

  test "play_round ends game when the next state results in a win" do
    verify_call Game.stop do
      Game.play_round(:some_state, fn :some_state -> {:win, "winner"} end)
      assert_output "game_won: winner\n"
    end
  end

  test "play_round ends game when the next state results in a tie" do
    verify_call Game.stop do
      Game.play_round(:some_state, fn :some_state -> {:tie} end)
      assert_output "game_tie\n"
    end
  end

  test "play_round starts next round if the game is still in_progress" do
    verify_call Game.play_round(:next_state) do
      Game.play_round(:state, fn :state -> {:in_progress, :next_state} end)
    end
  end

  test "stop starts a new game if the user wants to play again" do
    verify_call Game.start do
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
end
