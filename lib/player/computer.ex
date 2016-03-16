defmodule Player.Computer do
  use Player, :computer
  alias Player.Move

  defmodule Score do
    @type t :: integer

    @unit 1

    def max, do: @unit

    def zero, do: 0

    def min, do: -@unit
  end

  defmodule Choice do
    @type t :: %Choice{move: Move, board: Board.t}
    defstruct move: nil, board: nil

    def new(board, move) do
      %Choice{board: board, move: move}
    end

    @spec evaluate(Choice.t) :: Score.t
    def evaluate(%{move: move, board: board}) do
      new_board = move |> Move.apply_to(board)
      case Board.check_status(new_board) do
        :win -> Score.max
        :tie -> Score.zero
        :in_progress ->
          opponent_moves = all_for(new_board, Move.next_sign(move))
          -evaluate best_of opponent_moves
      end
    end

    @spec best_of([t]) :: t
    def best_of(choices) do
      Enum.max_by(choices, &evaluate/1)
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
