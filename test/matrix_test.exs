defmodule MatrixTest do
  defmacro __using__(matrix_impl) do
    quote do
      use ExUnit.Case

      @moduletag :rewrite

      test "can create new matrix form enumerable" do
        assert [[1, 2], [3, 4]] == Matrix.rows from_enum 1..4
      end

      test "can create new matrix form rows" do
        assert [[1, 2], [3, 4]] == Matrix.rows from_rows [[1, 2], [3, 4]]
      end

      test "map function on matrix" do
        assert from_enum(2..5) == Matrix.map from_enum(1..4), &(&1 + 1)
      end

      test "all?" do
        assert true == Matrix.all? from_enum(1..4), &(&1 < 5)
        assert false == Matrix.all? from_enum(1..4), &(&1 < 2)
      end

      test "columns" do
        assert [[1, 3], [2, 4]] == Matrix.columns from_enum 1..4
      end

      test "diagonals" do
        assert {[1, 5, 9], [3, 5, 7]} == Matrix.diagonals from_enum 1..9
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
