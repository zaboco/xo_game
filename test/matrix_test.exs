defmodule MatrixTest do
  defmacro __using__(matrix_impl) do
    quote do
      use ExUnit.Case

      test "can create new matrix form enumerable" do
        assert from_enum(1..4) |> Matrix.rows == [[1, 2], [3, 4]]
      end

      test "can create new matrix form rows" do
        assert from_rows([[1, 2], [3, 4]]) |> Matrix.rows == [[1, 2], [3, 4]]
      end

      test "map function on matrix" do
        assert from_enum(1..4) |> Matrix.map(& &1 + 1) == from_enum(2..5)
      end

      test "matrix implement Enumerable" do
        assert from_enum(1..4) |> Enum.all?(& &1 < 5) == true
        assert from_enum(1..4) |> Enum.all?(& &1 < 2) == false
      end

      test "columns" do
        assert from_enum(1..4) |> Matrix.columns == [[1, 3], [2, 4]]
      end

      test "diagonals" do
        assert from_enum(1..9) |> Matrix.diagonals == {[1, 5, 9], [3, 5, 7]}
      end

      defp from_enum(list) do
        unquote(matrix_impl).from_enum list
      end

      defp from_rows(matrix) do
        unquote(matrix_impl).from_rows matrix
      end
    end
  end
end

defmodule LinearMatrixTest do
  use MatrixTest, Matrix.LinearMatrix
end

defmodule NestedMatrixTest do
  use MatrixTest, Matrix.NestedMatrix
end
