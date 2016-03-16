defmodule Player.Computer do
  use Player, :computer
  alias Player.Move

  defmodule Score do
    @type t :: {:known, integer} | {:unknown, (() -> t)}

    @unit 1

    def max, do: {:known, @unit}
    def zero, do: {:known, 0}
    def min, do: {:known, -@unit}
    def unknown(generator), do: {:unknown, generator}

    @spec expand(t) :: t
    def expand({:unknown, generator}), do: generator.()
    def expand(known_score), do: known_score

    @spec negate(t) :: t
    def negate({:known, value}), do: {:known, -value}

    @spec max?(t) :: boolean
    def max?(score), do: score == max
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
      Map.get(choices_map, Score.max, best_in_map(choices_map))
    end

    @spec best_in_map(%{Score.t => t}) :: t
    defp best_in_map(choices_map) do
      choices_map
      |> Enum.max_by(fn {score, _choice} -> Score.expand(score) end)
      |> elem(1)
    end

    @spec all_for(Board.t, Player.sign) :: [t]
    def all_for(board, sign) do
      board
      |> Board.empty_cell_indexes
      |> Stream.map(&Move.new &1, sign)
      |> Enum.map(&%Choice{move: &1, board: board})
    end

    def move_index(%{move: move}), do: Move.index(move)
  end

  def get_move_index(sign, board) do
    board
    |> Choice.all_for(sign)
    |> Choice.best_of
    |> Choice.move_index
  end
end
