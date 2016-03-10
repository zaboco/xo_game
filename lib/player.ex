defmodule Player do
  @type t :: Player
  @type sign :: :x | :o

  @callback get_move_index(sign, board :: Board.t) :: 0..8
  @callback as_string(sign) :: String.t

  defmacro __using__(type) do
    quote do
      defstruct sign: :x

      def as_string(sign), do: "#{sign}(#{unquote(type)})"

      defoverridable [as_string: 1]
    end
  end

  def get_move(%{__struct__: module, sign: sign}, board) do
    {module.get_move_index(sign, board), sign}
  end

  def show(%{__struct__: module, sign: sign}) do
    module.as_string(sign)
  end
end
