defmodule Day9 do
  def parse_input() do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, "")
      |> Enum.filter(fn line -> line != "" end)
      |> Enum.map(&String.to_integer/1)
    end)
    |> wrapper()
    |> Enum.map(fn risk -> risk + 1 end)
    |> Enum.sum()
  end

  def wrapper(lst) do
    ind_lst =
      lst
      |> Enum.with_index()

    Enum.reduce(ind_lst, [], fn {digits, index}, acc ->
      acc ++ day9(ind_lst, digits, index, [])
    end)
  end

  def day9(lst, digits, index, init) do
    Enum.with_index(digits)
    |> Enum.reduce(init, fn
      {digit, dig_index}, acc ->
        # edge cases
        adj =
          cond do
            # First number
            dig_index == 0 and index == 0 ->
              [
                Enum.at(digits, dig_index + 1),
                Enum.at(Kernel.elem(Enum.at(lst, index + 1), 0), dig_index)
              ]
              |> Enum.filter(fn adj -> adj != nil end)

            # Canto inferior esquerdo
            index == length(lst) - 1 and dig_index == 0 ->
              [
                Enum.at(digits, dig_index + 1),
                Enum.at(Kernel.elem(Enum.at(lst, index - 1), 0), dig_index)
              ]
              |> Enum.filter(fn adj -> adj != nil end)

            # First line
            index == 0 ->
              [
                Enum.at(digits, dig_index - 1),
                Enum.at(digits, dig_index + 1),
                Enum.at(Kernel.elem(Enum.at(lst, index + 1), 0), dig_index)
              ]
              |> Enum.filter(fn adj -> adj != nil end)

            # Last line
            index == length(lst) - 1 ->
              [
                Enum.at(digits, dig_index - 1),
                Enum.at(digits, dig_index + 1),
                Enum.at(Kernel.elem(Enum.at(lst, index - 1), 0), dig_index)
              ]
              |> Enum.filter(fn adj -> adj != nil end)

            # First number in line
            dig_index == 0 ->
              [
                Enum.at(digits, dig_index + 1),
                Enum.at(Kernel.elem(Enum.at(lst, index + 1), 0), dig_index),
                Enum.at(Kernel.elem(Enum.at(lst, index - 1), 0), dig_index)
              ]
              |> Enum.filter(fn adj -> adj != nil end)

            true ->
              [
                Enum.at(Kernel.elem(Enum.at(lst, index - 1), 0), dig_index),
                Enum.at(digits, dig_index - 1),
                Enum.at(digits, dig_index + 1),
                Enum.at(Kernel.elem(Enum.at(lst, index + 1), 0), dig_index)
              ]
              |> Enum.filter(fn adj -> adj != nil end)
          end

        if Enum.any?(adj, fn adjn -> digit >= adjn end) do
          acc
        else
          [digit | acc]
        end
    end)
  end
end

IO.inspect(
  Day9.wrapper([
    [2, 1, 9, 9, 9, 4, 3, 2, 1, 0],
    [3, 9, 8, 7, 8, 9, 4, 9, 2, 1],
    [9, 8, 5, 6, 7, 8, 9, 8, 9, 2],
    [8, 7, 6, 7, 8, 9, 6, 7, 8, 9],
    [9, 8, 9, 9, 9, 6, 5, 6, 7, 8]
  ])
  |> Enum.map(fn risk -> risk + 1 end)
  |> Enum.sum()
)

IO.inspect(Day9.parse_input())
