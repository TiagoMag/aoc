defmodule Day1 do
  def parse_input() do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> parse_to_window()
    |> day1()
  end

  def parse_to_window(measures) do
    measures
    |> Enum.with_index()
    |> Enum.reduce_while([], fn {measure, index}, acc ->
      if index != length(measures) - 2 do
        {:cont, acc ++ [measure + Enum.at(measures, index + 1) + Enum.at(measures, index + 2)]}
      else
        {:halt, acc}
      end
    end)
  end

  def day1([hd | tail]) do
    day1_aux(tail, hd, [:na])
    |> Enum.filter(fn x -> x == :increased end)
    |> Enum.count()
  end

  def day1_aux([], _prev, output) do
    output
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

window_formatt =
  Day1.parse_to_window([199, 200, 208, 210, 200, 207, 240, 269, 260, 263]) |> IO.inspect()

IO.inspect(Day1.day1(window_formatt))
IO.inspect(Day1.parse_input())
