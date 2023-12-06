defmodule Day03 do

  def part1(input) do
    positions = parse(input)

    positions
    |> Enum.filter(&has_adjacent_symbol(&1, positions))
    |> Enum.map(&(&1.number))
    |> Enum.sum()
  end

  def part2(input) do
    positions = parse(input)

    positions
    |> Enum.map(&gear_parts(&1, positions))
    |> Enum.filter(&length(&1) >= 2)
    |> Enum.map(&calc_gear_ratio/1)
    |> Enum.sum()
  end

  defp gear_parts(pos = %{x: _, y: _, symbol: "*"}, positions) do
    pos_list = [pos]

    positions
    |> Enum.filter(&(&1[:number] != nil and has_adjacent_symbol(&1, pos_list)))
    |> Enum.map(&(&1.number))
  end
  defp gear_parts(_, _), do: []

  defp calc_gear_ratio(parts), do: parts |> Enum.reduce(1, &(&1 * &2))

  defp has_adjacent_symbol(%{x: x, y: y, number: number}, positions) do
    y_min = y - 1
    y_max = y + 1
    x_min = x - 1
    x_max = x + (number |> Integer.to_string() |> String.length())

    positions
    |> Enum.filter(fn p -> p[:symbol] != nil end)
    |> Enum.any?(fn p -> p.x >= x_min and p.x <= x_max and p.y >= y_min and p.y <= y_max end)
  end
  defp has_adjacent_symbol(_, _), do: false

  defp parse(schematic), do: parse(schematic, 0, 0)
  defp parse("", _, _), do: []
  defp parse("." <> rest, x, y), do: parse(rest, x + 1, y)
  defp parse("\r\n" <> rest, _, y), do: parse(rest, 0, y + 1)
  defp parse(schematic = <<num>> <> _, x, y) when num in ?0..?9 do
    pos = %{
      x: x,
      y: y,
      number: parse_number(schematic) |> String.to_integer()
    }

    skip = pos.number |> Integer.to_string() |> String.length()
    rest = String.slice(schematic, skip..-1)

    [pos | parse(rest, x + skip, y)]
  end

  defp parse(<<symbol::bytes-size(1)>> <> rest, x, y) do
    pos = %{
      x: x,
      y: y,
      symbol: symbol
    }

    [pos | parse(rest, x + 1, y)]
  end

  defp parse_number(<<num>> <> rest) when num in ?0..?9, do: <<num>> <> parse_number(rest)
  defp parse_number(_), do: ""
end
