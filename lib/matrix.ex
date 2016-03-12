defmodule Matrix.Behaviour do
  @callback from_enum(Enumerable.t) :: Matrix.t
  @callback from_enum(Enumerable.t, number) :: Matrix.t
  @callback from_rows([[any]]) :: Matrix.t

  defmacro __using__(_) do
    quote do
      @behaviour Matrix.Behaviour

      def from_enum(enumerable) do
        width = enumerable |> Enum.to_list |> length |> :math.sqrt |> round
        from_enum enumerable, width
      end
    end
  end
end

defprotocol Matrix do
  @spec rows(t) :: [[any]]
  def rows(matrix)

  @spec columns(t) :: [[any]]
  def columns(matrix)

  @spec diagonals(t) :: {[any], [any]}
  def diagonals(matrix)

  @spec map(t, (any -> any)) :: t
  def map(matrix, fun)
end
