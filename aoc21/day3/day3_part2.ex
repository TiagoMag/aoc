defmodule Day3 do
  def parse_input() do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn binary_number -> String.graphemes(binary_number) end)
    |> day3()
  end

  def day3(binary_numbers) do
    ox_rating = bit_criteria(:most, 0, binary_numbers, binary_numbers)
    co2_rating = bit_criteria(:less, 0, binary_numbers, binary_numbers)
    ox_binary = List.to_string(ox_rating)
    co2_binary = List.to_string(co2_rating)
    ox_binary_as_decimal = Integer.parse(ox_binary, 2) |> elem(0)
    co2_binary_as_decimal = Integer.parse(co2_binary, 2) |> elem(0)
    ox_binary_as_decimal * co2_binary_as_decimal
  end

  def bit_criteria(_criteria, _index, _binary_numbers, res) when length(res) == 1 do
    res
  end

  def bit_criteria(criteria, index, binary_numbers, res) do
    bits = Enum.map(res, fn x -> Enum.at(x, index) end)
    number_of_1 = Enum.count(bits, fn x -> "1" == x end)
    number_of_0 = Enum.count(bits, fn x -> "0" == x end)

    keep =
      case criteria do
        :most ->
          cond do
            number_of_1 >= number_of_0 -> {"1", number_of_1}
            true -> {"0", number_of_0}
          end

        :less ->
          cond do
            number_of_1 >= number_of_0 -> {"0", number_of_0}
            true -> {"1", number_of_1}
          end
      end

    new_bits =
      Enum.filter(res, fn x -> Enum.at(x, index) == Kernel.elem(keep, 0) end)
      |> Enum.take(Kernel.elem(keep, 1))

    bit_criteria(
      criteria,
      index + 1,
      binary_numbers,
      new_bits
    )
  end
end

IO.inspect(Day3.parse_input())
