defmodule Day06 do

  def part1(input) do
    input
    |> parse()
    |> Enum.map(&ways_to_win/1)
    |> Enum.reduce(1, & &1 * &2)
  end

  def part2(input) do
    input
    |> parse_giga_race()
    |> ways_to_win()
  end

  defp ways_to_win(%{distance: distance, time: time}), do: Enum.count(1..time, &calc_distance(time, &1) > distance)

  defp calc_distance(time, hold), do: hold * (time - hold)

  defp parse(input) do
    values =
      Regex.scan(~r/\d+/, input)
      |> Enum.map(&hd/1)
      |> Enum.map(&String.to_integer/1)

    races_count = values |> length() |> div(2)
    times = Enum.slice(values, 0, races_count)
    distances = Enum.slice(values, races_count, races_count)

    times
    |> Enum.with_index()
    |> Enum.map(fn {t, index} -> %{time: t, distance: Enum.at(distances, index)} end)
  end

  defp parse_giga_race(input) do
    values =
      input
      |> String.replace(" ", "")
      |> then(&Regex.scan(~r/\d+/, &1))
      |> Enum.map(&hd/1)
      |> Enum.map(&String.to_integer/1)

    %{time: Enum.at(values, 0), distance: Enum.at(values, 1)}
  end
end
