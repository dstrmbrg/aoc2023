defmodule Day09 do

  def part1(input) do
    input
    |> parse()
    |> Enum.map(&grow/1)
    |> Enum.map(&List.last/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse()
    |> Enum.map(&Enum.reverse/1)
    |> Enum.map(&grow/1)
    |> Enum.map(&List.last/1)
    |> Enum.sum()
  end

  defp grow(list) do
    next_value =
      [list] ++ calc_sub_sequences(list)
      |> Enum.map(&List.last/1)
      |> Enum.sum()

    list ++ [next_value]
  end

  defp calc_sub_sequences(list) do
    sequence =
      list
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(&Enum.at(&1, 1) - Enum.at(&1, 0))

    if Enum.all?(sequence, & &1 == 0) do
      [sequence]
    else
      [sequence] ++ calc_sub_sequences(sequence)
    end
  end

  defp parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(row) do
    row
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
  end
end
