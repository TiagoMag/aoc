defmodule Day5 do
  def parse_input() do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split([",", " -> "])
      |> Enum.map(&String.to_integer/1)
    end)
    |> day5
  end

  def day5(lst) do
    map =
      Enum.reduce(lst, %{}, fn coords, acc ->
        case coords do
          [x, y1, x, y2] ->
            Enum.reduce(y1..y2, acc, fn y, acc ->
              Map.update(acc, {x, y}, 1, fn old -> old + 1 end)
            end)

          [x1, y, x2, y] ->
            Enum.reduce(x1..x2, acc, fn x, acc ->
              Map.update(acc, {x, y}, 1, fn old -> old + 1 end)
            end)

          [x1, y1, x2, y2] ->
            poss = Enum.zip(x1..x2, y1..y2)

            Enum.reduce(poss, acc, fn p, acc ->
              Map.update(acc, p, 1, fn old -> old + 1 end)
            end)
        end
      end)

    Enum.count(map, fn {_k, v} -> v > 1 end)
  end
end

IO.inspect(Day5.parse_input())
