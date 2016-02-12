defmodule BoardTest do
  use ExUnit.Case
  import Board

  @some_board [
    [:x, :_, :_],
    [:o, :_, :_],
    [:_, :_, :_],
  ]

  test "sigil b transforms a colon-delimited string into a board" do
    assert ~b|x _ _ : o _ _ : _ _ _| == @some_board
  end

  test "sigil B uses newline as a delimiter" do
    assert ~B"""
      x _ _
      o _ _
      _ _ _
    """ == @some_board
  end
end
