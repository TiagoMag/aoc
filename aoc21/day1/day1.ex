defmodule Day1 do
  def input() do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> day1()
  end

  def day1([hd | tail]) do
    day1_aux(tail, hd, [:na])
    |> Enum.filter(fn x -> x == :increased end)
    |> Enum.count()
  end

  def day1_aux([], _prev, output) do
    output |> IO.inspect()
  end

  def day1_aux([hd | tail], prev, output) do
    res =
      cond do
        hd > prev -> :increased
        true -> :decreased
      end

    day1_aux(tail, hd, [res | output])
  end
end

IO.puts(Day1.day1([199, 200, 208, 210, 200, 207, 240, 269, 260, 263]))
IO.puts(Day1.input())
