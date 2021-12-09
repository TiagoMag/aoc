defmodule Day3 do
  def parse_input() do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn binary_number -> String.graphemes(binary_number) end)
    |> day3()
  end

  def day3(binary_numbers) do
    cols = length(Enum.at(binary_numbers, 0))
    lines = length(binary_numbers)
    {gamma, epsilon} = find_common_bits(0, binary_numbers, cols, lines, [], [])
    gamma_binary = List.to_string(gamma)
    epsilon_binary = List.to_string(epsilon)
    gamma_binary_as_decimal = Integer.parse(gamma_binary, 2) |> elem(0)
    epsilon_binary_as_decimal = Integer.parse(epsilon_binary, 2) |> elem(0)
    gamma_binary_as_decimal * epsilon_binary_as_decimal
  end

  def find_common_bits(index, _binary_numbers, cols, _lines, gamma, epsilon) when index == cols do
    {gamma, epsilon}
  end

  def find_common_bits(index, binary_numbers, cols, lines, gamma, epsilon) do
    bits = Enum.map(binary_numbers, fn x -> Enum.at(x, index) end)
    number_of_1 = Enum.count(bits, fn x -> "1" == x end)
    number_of_0 = Enum.count(bits, fn x -> "0" == x end)

    {new_gama, new_epsilon} =
      cond do
        number_of_1 > number_of_0 -> {"1", "0"}
        true -> {"0", "1"}
      end

    find_common_bits(
      index + 1,
      binary_numbers,
      cols,
      lines,
      List.insert_at(gamma, index, new_gama),
      List.insert_at(epsilon, index, new_epsilon)
    )
  end
end

IO.inspect(Day3.parse_input())
