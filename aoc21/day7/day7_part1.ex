defmodule Day7 do
  # Brute force solution, median would be optimized solution
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
          Kernel.abs(position - p)
        end)
        |> Enum.sum()

      [sum | acc]
    end)
    |> Enum.min()
  end
end

IO.inspect(Day7.parse_input())
