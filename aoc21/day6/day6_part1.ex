defmodule Day6 do
  def parse_input(days) do
    File.read!("input.txt")
    |> String.split(["\n", ","], trim: true)
    |> Enum.map(fn timer -> String.to_integer(timer) end)
    |> day6(days)
  end

  def day6(timers, days) do
    num_fishes = Enum.count(timers, fn timer -> timer == 0 end)
    new_timers = update_time(timers, days, num_fishes)
    length(new_timers)
  end

  def update_time(timers, 0, _) do
    timers
  end

  def update_time(timers, days, new_fishes) do
    new_timers =
      Enum.map(timers, fn timer ->
        case timer do
          0 -> 6
          _ -> timer - 1
        end
      end)

    num_fishes = Enum.count(new_timers, fn timer -> timer == 0 end)
    new_timers = new_timers ++ List.duplicate(8, new_fishes)

    update_time(new_timers, days - 1, num_fishes)
  end
end

IO.inspect(Day6.day6([3, 4, 3, 1, 2], 18))
IO.inspect(Day6.parse_input(80))
