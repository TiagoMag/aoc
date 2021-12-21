defmodule Day7 do
  def parse_input() do
    File.read!("input.txt")
    |> String.split(["\n", ","], trim: true)
    |> Enum.map(fn position -> String.to_integer(position) end)
    |> day7()
  end

  def day7(positions) do
    {min, max} = Enum.min_max(positions)

    Enum.reduce(min..max, [], fn p, acc ->
      sum =
        Enum.map(positions, fn position ->
          calc_fuel(position, p)
        end)
        |> Enum.sum()

      [sum | acc]
    end)
    |> Enum.min()
  end

  def calc_fuel(position1, position2) do
    Enum.sum(0..Kernel.abs(position1 - position2))
  end
end

IO.inspect(Day7.day7([16, 1, 2, 0, 4, 2, 7, 1, 2, 14]))
IO.inspect(Day7.parse_input())
