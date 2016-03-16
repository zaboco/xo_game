defmodule Player do
  alias Player.Move

  @type t :: %{}
  @type sign :: :x | :o
  @type move_index :: 0..8

  @callback get_move_index(sign, board :: Board.t) :: move_index
  @callback as_string(sign) :: String.t

  defmacro __using__(type) do
    quote do
      defstruct sign: :x

      def as_string(sign), do: "#{sign}(#{unquote(type)})"

      defoverridable [as_string: 1]
    end
  end

  def get_move(%{__struct__: module, sign: sign}, board) do
    Move.new(module.get_move_index(sign, board), sign)
  end

  def show(%{__struct__: module, sign: sign}) do
    module.as_string(sign)
  end
end
