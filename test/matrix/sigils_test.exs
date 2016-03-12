defmodule Matrix.SigilsTest do
  use ExUnit.Case
  import Matrix.Sigils, only: [sigil_m: 2]

  test "sigil_m makes a matrix of atoms" do
    assert ~m|a b : c d| == [[:a, :b], [:c, :d]]
  end

  test "sigil_m handles multi-line" do
    assert ~m"""
      a b
      c d
    """ == [[:a, :b], [:c, :d]]
  end
end
