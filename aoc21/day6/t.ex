defmodule Recursion1 do
  def recur(fishes) do
    recur(fishes, [])
  end

  defp recur([0 | fishes], children), do: [6 | recur(fishes, [8 | children])]
  defp recur([fish | fishes], children), do: [fish - 1 | recur(fishes, children)]
  defp recur([], children), do: Enum.reverse(children)
end

fishes =
  File.read!("input.txt")
  |> String.split(",", trim: true)
  |> Enum.map(&String.to_integer/1)

1..256
|> Enum.reduce(fishes, fn _, fishes -> Recursion1.recur(fishes) end)
|> length()
