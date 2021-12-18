defmodule Day4 do
  def parse_input() do
    list =
      File.read!("input.txt")
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {line, index} ->
        if index == 0 do
          String.split(line, ",", trim: true)
          |> Enum.map(&String.to_integer/1)
        else
          String.split(line, " ", trim: true)
          |> Enum.map(&String.to_integer/1)
        end
      end)

    day4({hd(list), slice_list(0, list, [])})
  end

  def slice_list(index, list, res) when index == div(length(list), 5) do
    res
  end

  def slice_list(index, list, res) do
    new_res = res ++ [Enum.slice(list, index * 5 + 1, 5)]
    slice_list(index + 1, list, new_res)
  end

  def init_res(size) do
    value = List.duplicate(0, 5)
    final = List.duplicate(value, 5)
    List.duplicate(final, size)
  end

  def day4({draw, boards}) do
    res = init_res(length(boards))
    value = List.duplicate(0, length(boards))

    {{marks, _, board_index, last_draw}, _} =
      Enum.reduce_while(draw, {{res, :not_bingo, 0, 0}, value}, fn draw_num, acc ->
        new_acc = iterate_boards(draw_num, boards, acc)

        case new_acc do
          {{a, :bingo, b, c}, lst} -> {:halt, {{a, :bingo, b, c}, lst}}
          {{a, :not_bingo, b, c}, lst} -> {:cont, {{a, :not_bingo, b, c}, lst}}
        end
      end)

    sum = sum_unmarked(Enum.at(marks, board_index), Enum.at(boards, board_index))
    sum * last_draw
  end

  def sum_unmarked(marks, board) do
    Enum.with_index(board)
    |> Enum.reduce(0, fn {line, line_index}, acc ->
      unm =
        Enum.filter(Enum.with_index(line), fn {_num, num_index} ->
          Enum.at(Enum.at(marks, line_index), num_index) == 0
        end)

      acc + Enum.sum(Enum.map(unm, fn x -> Kernel.elem(x, 0) end))
    end)
  end

  def iterate_boards(draw_num, boards, res) do
    Enum.with_index(boards)
    |> Enum.reduce_while(res, fn {board, board_index}, {acc, lst} ->
      if Enum.at(lst, board_index) == 0 do
        new_acc = iterate_board(board, length(boards), {acc, lst}, board_index, draw_num)

        case new_acc do
          {{_, :bingo, _, _}, _} -> {:halt, new_acc}
          _ -> {:cont, new_acc}
        end
      else
        {:cont, {acc, lst}}
      end
    end)
  end

  def iterate_board(board, boards_num, res, board_index, draw_num) do
    Enum.with_index(board)
    |> Enum.reduce_while(res, fn {board_line, line_index}, {acc, lst_bingos} ->
      new_acc = iterate_board_line(board_line, acc, board_index, line_index, draw_num)

      case new_acc do
        {a, :bingo, board_index, b} ->
          new_lst_bingos = List.replace_at(lst_bingos, board_index, 1)

          if check_last(new_lst_bingos, boards_num) do
            {:halt, {new_acc, new_lst_bingos}}
          else
            {:cont, {{a, :not_bingo, board_index, b}, new_lst_bingos}}
          end

        _ ->
          {:cont, {new_acc, lst_bingos}}
      end
    end)
  end

  def check_last(lst, boards_num) do
    sum = Enum.count(lst, fn x -> x == 1 end)
    sum == boards_num
  end

  def iterate_board_line(board_line, acc, board_index, line_index, draw_num) do
    Enum.with_index(board_line)
    |> Enum.reduce_while(acc, fn {num, num_index}, {ac, _, _, _} ->
      if num == draw_num do
        board = Enum.at(ac, board_index)
        board_line = Enum.at(board, line_index)
        new_board_line = List.replace_at(board_line, num_index, 1)
        new_board = List.replace_at(board, line_index, new_board_line)
        new_acc = List.replace_at(ac, board_index, new_board)
        count_l = check_line(new_board_line)
        count_c = check_col(num_index, new_board)

        if count_l == 5 or count_c == 5 do
          {:halt, {new_acc, :bingo, board_index, draw_num}}
        else
          {:cont, {new_acc, :not_bingo, board_index, draw_num}}
        end
      else
        {:cont, {ac, :not_bingo, board_index, draw_num}}
      end
    end)
  end

  def check_line(line) do
    Enum.count(line, fn x -> x == 1 end)
  end

  def check_col(col_ind, board) do
    lst = Enum.map(board, fn line -> Enum.at(line, col_ind) end)
    Enum.count(lst, fn x -> x == 1 end)
  end
end

IO.puts(Day4.parse_input())
