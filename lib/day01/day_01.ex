defmodule Day01 do

  def part1(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.map(&parse_digits/1)
    |> Enum.map(&(List.first(&1) * 10 + List.last(&1)))
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.map(&parse_digits_with_letters/1)
    |> Enum.map(&(List.first(&1) * 10 + List.last(&1)))
    |> Enum.sum()
  end

  defp parse_digits(<<num>> <> rest) when num in ?0..?9, do: [[num] |> List.to_string |> String.to_integer | parse_digits(rest)]
  defp parse_digits(<<_::bytes-size(1)>> <> rest), do: parse_digits(rest)
  defp parse_digits(""), do: []

  defp parse_digits_with_letters(<<num>> <> rest) when num in ?0..?9, do: [[num] |> List.to_string |> String.to_integer | parse_digits_with_letters(rest)]
  defp parse_digits_with_letters(str = "one" <> _), do: [1 | parse_digits_with_letters_rest(str)]
  defp parse_digits_with_letters(str = "two" <> _), do: [2 | parse_digits_with_letters_rest(str)]
  defp parse_digits_with_letters(str = "three" <> _), do: [3 | parse_digits_with_letters_rest(str)]
  defp parse_digits_with_letters(str = "four" <> _), do: [4 | parse_digits_with_letters_rest(str)]
  defp parse_digits_with_letters(str = "five" <> _), do: [5 | parse_digits_with_letters_rest(str)]
  defp parse_digits_with_letters(str = "six" <> _), do: [6 | parse_digits_with_letters_rest(str)]
  defp parse_digits_with_letters(str = "seven" <> _), do: [7 | parse_digits_with_letters_rest(str)]
  defp parse_digits_with_letters(str = "eight" <> _), do: [8 | parse_digits_with_letters_rest(str)]
  defp parse_digits_with_letters(str = "nine" <> _), do: [9 | parse_digits_with_letters_rest(str)]
  defp parse_digits_with_letters(<<_::bytes-size(1)>> <> rest), do: parse_digits_with_letters(rest)
  defp parse_digits_with_letters(""), do: []

  defp parse_digits_with_letters_rest(<<_::bytes-size(1)>> <> rest), do: parse_digits_with_letters(rest)
end
