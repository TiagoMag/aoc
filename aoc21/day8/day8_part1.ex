defmodule Day8 do
  def parse_input() do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("|", trim: true)
      |> Enum.at(1)
      |> String.split(" ", trim: true)
    end)
    |> Enum.map(fn line ->
      Enum.filter(line, fn seg ->
        String.length(seg) == 2 or String.length(seg) == 3 or String.length(seg) == 4 or
          String.length(seg) == 7
      end)
    end)
    |> Enum.reduce(0, fn line, acc ->
      acc + Enum.count(line)
    end)
  end
end

IO.inspect(Day8.parse_input())
