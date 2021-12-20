defmodule Day6 do
  def parse_input(days) do
    File.read!("input.txt")
    |> String.split(["\n", ","], trim: true)
    |> Enum.map(fn timer -> String.to_integer(timer) end)
    |> day6(days)
  end

  def day6(timers, days) do
    timers
    |> Enum.frequencies()
    |> update_time(days)
    |> Map.values()
    |> Enum.sum()
  end

  def update_time(timers, 0) do
    timers
  end

  def update_time(timers, day) do
    {count, timers} = Map.pop(timers, 0, 0)

    new =
      timers
      |> Enum.map(fn {n, k} -> {n - 1, k} end)
      |> Map.new()
      |> Map.merge(%{6 => count, 8 => count}, fn _, x, y -> x + y end)

    update_time(new, day - 1)
  end
end

IO.inspect(Day6.day6([3, 4, 3, 1, 2], 18))
IO.inspect(Day6.parse_input(256))
