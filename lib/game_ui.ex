defmodule GameUI do
  @doc """
  Reads index for of the next move
  """
  @callback read_index :: String.t

  @doc """
  Reads player type ("human" or "computer")
  """
  @callback read_player_type(Board.sign) :: String.t

  @doc """
  Prints the given matrix
  """
  @callback print_matrix([[any]]) :: nil

  @doc """
  Logs a certain message, given by a key and an optional value
  """
  @typep message_type :: :wrong_index
  @callback log(message_type, any) :: nil
end
