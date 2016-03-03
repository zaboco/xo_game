defmodule GameUI do
  @callback read_index :: String.t

  @callback read_player_type() :: String.t

  @callback print_matrix([[any]]) :: nil

  @callback log(atom, any) :: nil
end
