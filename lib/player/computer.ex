defmodule Player.Computer do
  alias Player.Move

  def name, do: "computer"

  defmodule Score do
    @type t :: {:known, integer} | {:unknown, (() -> t)}

    @unit 1
    @max {:known, @unit}

    def max, do: @max
    def zero, do: {:known, 0}
    def min, do: negate @max
    def unknown(generator), do: {:unknown, generator}

    @spec expand(t) :: t
    def expand({:unknown, generator}), do: generator.()
    def expand(known_score), do: known_score

    @spec negate(t) :: t
    def negate({:known, value}), do: {:known, -value}

    @spec max?(t) :: boolean
    def max?(score), do: score == max

    @spec best_in([t]) :: t
    def best_in(scores) do
      scores
      |> Enum.reduce_while([], &do_lazy_expand/2)
      |> Enum.max
      |> elem(1)
    end

    defp do_lazy_expand(score, prev_scores) do
      case expand(score) do
        @max -> {:halt, [{@max, score} | prev_scores]}
        other -> {:cont, [{other, score} | prev_scores]}
      end
    end
  end

  defmodule Choice do
    @type t :: %Choice{move: Move, board: Board.t}
    defstruct move: nil, board: nil

    def new(board, move) do
      %Choice{board: board, move: move}
    end

    @spec evaluate(Choice.t) :: Score.t
    def evaluate(choice) do
      Score.expand pre_evaluate choice
    end

    @spec pre_evaluate(Choice.t) :: Score.t
    defp pre_evaluate(%{move: move, board: board}) do
      new_board = move |> Move.apply_to(board)
      case Board.check_status(new_board) do
        :win -> Score.max
        :tie -> Score.zero
        :in_progress ->
          opponent_moves = all_for(new_board, Move.next_sign(move))
          Score.unknown(fn -> Score.negate evaluate best_of opponent_moves end)
      end
    end

    @spec best_of([t]) :: t
    def best_of(choices) do
      choices_map = Map.new(choices, &{pre_evaluate(&1), &1})
      best_score = Score.best_in(Map.keys choices_map)
      Map.get(choices_map, best_score)
    end

    @spec all_for(Board.t, Player.sign) :: [t]
    def all_for(board, sign) do
      board
      |> Board.indexes_where(&is_nil/1)
      |> Stream.map(&Move.new &1, sign)
      |> Enum.map(&%Choice{move: &1, board: board})
    end

    def move_index(%{move: move}), do: Move.index(move)
  end

  def score_matrix(board, sign) do
    Board.to_matrix board, fn index ->
      choice = Choice.new(board, Move.new(index, sign))
      {:known, score} = Choice.evaluate(choice)
      score
    end
  end

  def get_move_index(sign, board) do
    filled_cell_indexes = Board.indexes_where(board, & not is_nil &1)
    case filled_cell_indexes do
      [] -> opening_for_empty_board()
      [index] -> opening_for_one_cell_board(index)
      _ -> calculate_best_index(sign, board)
    end
  end

  defp calculate_best_index(sign, board) do
    board
    |> Choice.all_for(sign)
    |> Choice.best_of
    |> Choice.move_index
  end

  defp opening_for_empty_board() do
    random_corner Board.size
  end

  defp opening_for_one_cell_board(index) do
    center = &div(&1 * &1, 2)
    case center.(Board.size) do
      ^index -> random_corner Board.size
      center -> center
    end
  end

  defp random_corner(size) do
    Enum.random [0, size - 1, size * (size - 1), size * size - 1]
  end
end
