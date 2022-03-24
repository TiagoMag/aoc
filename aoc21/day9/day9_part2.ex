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
    |> Enum.map(fn basin -> length(basin) end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  def wrapper(lst) do
    ind_lst =
      lst
      |> Enum.with_index()

    Enum.reduce(ind_lst, [], fn {digits, index}, acc ->
      acc ++ day9(ind_lst, digits, index, [])
    end)
  end

  def is_visited?(visited, posx, posy) do
    Map.has_key?(visited, {posx, posy})
  end

  def basin(digit, visited, to_visit, n_posx, n_posy, result, lst, digits) do
    # add to visited
    new_visited = Map.put(visited, {n_posx, n_posy}, 1)
    # neighbors
    nei = find_adj(lst, n_posy, n_posx)
    # IO.inspect(new_to_visit)
    # filter visited and digits equal to 9
    res =
      Enum.filter(nei, fn {digit, x, y} ->
        !is_visited?(visited, x, y) and digit != 9 and !Enum.member?(result, {digit, x, y})
      end)

    new_to_visit = List.delete(to_visit ++ res, {digit, n_posx, n_posy})
    # updates the result

    if new_to_visit == [] do
      result
    else
      new_result = result ++ res
      {next_digit, x, y} = hd(new_to_visit)

      basin(
        next_digit,
        new_visited,
        new_to_visit,
        x,
        y,
        new_result,
        lst,
        digits
      )
    end

    # recur
  end

  def find_adj(lst, index, dig_index) do
    digits = Kernel.elem(Enum.at(lst, index), 0)

    cond do
      # First number
      dig_index == 0 and index == 0 ->
        [
          {Enum.at(digits, dig_index + 1), dig_index + 1, index},
          {Enum.at(Kernel.elem(Enum.at(lst, index + 1), 0), dig_index), dig_index, index + 1}
        ]
        |> Enum.filter(fn {adj, _, _} -> adj != nil end)

      # Canto inferior esquerdo
      index == length(lst) - 1 and dig_index == 0 ->
        [
          {Enum.at(digits, dig_index + 1), dig_index + 1, index},
          {Enum.at(Kernel.elem(Enum.at(lst, index - 1), 0), dig_index), dig_index, index - 1}
        ]
        |> Enum.filter(fn {adj, _, _} -> adj != nil end)

      # First line
      index == 0 ->
        [
          {Enum.at(digits, dig_index - 1), dig_index - 1, index},
          {Enum.at(digits, dig_index + 1), dig_index + 1, index},
          {Enum.at(Kernel.elem(Enum.at(lst, index + 1), 0), dig_index), dig_index, index + 1}
        ]
        |> Enum.filter(fn {adj, _, _} -> adj != nil end)

      # Last line
      index == length(lst) - 1 ->
        [
          {Enum.at(digits, dig_index - 1), dig_index - 1, index},
          {Enum.at(digits, dig_index + 1), dig_index + 1, index},
          {Enum.at(Kernel.elem(Enum.at(lst, index - 1), 0), dig_index), dig_index, index - 1}
        ]
        |> Enum.filter(fn {adj, _, _} -> adj != nil end)

      # First number in line
      dig_index == 0 ->
        [
          {Enum.at(digits, dig_index + 1), dig_index + 1, index},
          {Enum.at(Kernel.elem(Enum.at(lst, index + 1), 0), dig_index), dig_index, index + 1},
          {Enum.at(Kernel.elem(Enum.at(lst, index - 1), 0), dig_index), dig_index, index - 1}
        ]
        |> Enum.filter(fn {adj, _, _} -> adj != nil end)

      true ->
        [
          {Enum.at(Kernel.elem(Enum.at(lst, index - 1), 0), dig_index), dig_index, index - 1},
          {Enum.at(digits, dig_index - 1), dig_index - 1, index},
          {Enum.at(digits, dig_index + 1), dig_index + 1, index},
          {Enum.at(Kernel.elem(Enum.at(lst, index + 1), 0), dig_index), dig_index, index + 1}
        ]
        |> Enum.filter(fn {adj, _, _} -> adj != nil end)
    end
  end

  def day9(lst, digits, index, init) do
    Enum.with_index(digits)
    |> Enum.reduce(init, fn
      {digit, dig_index}, acc ->
        adj = find_adj(lst, index, dig_index)

        if Enum.any?(adj, fn {adjn, _posx, _posy} -> digit >= adjn end) do
          acc
        else
          [
            basin(
              digit,
              %{},
              [{digit, dig_index, index}],
              dig_index,
              index,
              [{digit, dig_index, index}],
              lst,
              digits
            )
            | acc
          ]
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
  |> Enum.map(fn basin -> length(basin) end)
  |> Enum.sort(:desc)
  |> Enum.take(3)
  |> Enum.product()
)

IO.inspect(Day9.parse_input())
