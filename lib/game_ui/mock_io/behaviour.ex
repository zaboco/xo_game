defmodule GameUI.MockIO.Behaviour do
  @callback gets(prompt :: String.t) :: String.t
  @callback puts(item :: String.t) :: :ok
  @callback write(item :: String.t) :: :ok

  defmacro __using__(_) do
    quote do
      def puts(item) do
        __MODULE__.write(item <> "\n")
      end
    end
  end
end
