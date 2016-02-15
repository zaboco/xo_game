defmodule Players do
  def get_move board, {sign, player_type} do
    case player_type do
      :human -> Players.Human.read_move board, sign
      :computer -> Players.Computer.calculate_move board, sign
    end
  end

  def swap [current, next] do
    [next, current]
  end

  def show_current [{sign, type}, _next] do
    "#{sign}(#{type})"
  end
end
