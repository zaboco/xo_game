defmodule Players do
  alias Player.{Human, Computer}

  def get_current_move([current, _other], board) do
    Player.get_move current, board
  end

  def swap([current, next]) do
    [next, current]
  end

  def show_current([current, _other]) do
    Player.show current
  end
end
