defmodule Day11 do

  def part1(input), do: solve(input, 2)
  def part2(input), do: solve(input, 1_000_000)

  defp solve(input, expand_size) do
    input
    |> parse()
    |> expand(expand_size)
    |> Combination.combine(2)
    |> Enum.map(fn [{x1, y1}, {x2, y2}] -> abs(x1 - x2) + abs(y1 - y2) end)
    |> Enum.sum()
  end

  defp expand(galaxies, expand_size), do: Enum.map(galaxies, &next_position(&1, galaxies, expand_size))

  defp next_position({x, y}, galaxies, expand_size) do
    empty_cols = x - distinct_lt_count_by(galaxies, x, &elem(&1, 0))
    empty_rows = y - distinct_lt_count_by(galaxies, y, &elem(&1, 1))

    {x + (expand_size - 1) * empty_cols, y + (expand_size - 1) * empty_rows}
  end

  defp distinct_lt_count_by(enumerable, value, fun) do
    enumerable
    |> Enum.map(&fun.(&1))
    |> Enum.uniq()
    |> Enum.count(& &1 < value)
  end

  defp parse(input), do: parse(input, 0, 0)
  defp parse("", _, _), do: []
  defp parse("\n" <> rest, _, y), do: parse(rest, 0, y + 1)
  defp parse("#" <> rest, x, y), do: [{x, y} | parse(rest, x + 1, y)]
  defp parse(<<_::binary-size(1)>> <> rest, x, y), do: parse(rest, x + 1, y)
end
