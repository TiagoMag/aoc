defmodule Day2 do
  def parse_input() do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      [cmd, value] = String.split(x)
      {String.to_atom(cmd), String.to_integer(value)}
    end)
    |> day2()
    |> mult()
  end

  def day2(instructions) do
    Enum.reduce(instructions, {0, 0}, fn {cmd, value}, {hor, dep} ->
      case {cmd, value} do
        {:forward, value} -> {hor + value, dep}
        {:down, value} -> {hor, dep + value}
        {:up, value} -> {hor, dep - value}
      end
    end)
  end

  def mult({hor, dep}) do
    hor * dep
  end
end

IO.inspect(
  Day2.day2([{:forward, 5}, {:down, 5}, {:forward, 8}, {:up, 3}, {:down, 8}, {:forward, 2}])
  |> Day2.mult()
)

IO.inspect(Day2.parse_input())
