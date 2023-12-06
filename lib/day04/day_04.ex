defmodule Day04 do

  def part1(input) do
    input
    |> parse()
    |> Enum.map(&calculate_score/1)
    |> Enum.sum()
  end

  def part2(input) do
    cards = parse(input)
    copies = List.duplicate(1, Enum.count(cards))

    cards
    |> Enum.reduce(copies, fn c, acc -> win_copies(acc, c) end)
    |> Enum.sum()
  end

  defp win_copies(copies, %{numbers: numbers, winning_numbers: winning_numbers, card_nr: card_nr}) do
    count = Enum.at(copies, card_nr - 1)
    wins = Enum.count(numbers, fn n -> Enum.any?(winning_numbers, &(&1 == n)) end)

    copies
    |> Enum.with_index(&({&1, &2 + 1}))
    |> Enum.map(fn {c, nr} -> if nr > card_nr and nr <= card_nr + wins, do: c + count, else: c end)
  end

  defp calculate_score(%{numbers: numbers, winning_numbers: winning_numbers}) do
    numbers
    |> Enum.count(fn n -> Enum.any?(winning_numbers, &(&1 == n)) end)
    |> calculate_score_by_count()
  end

  defp calculate_score_by_count(0), do: 0
  defp calculate_score_by_count(n), do: 2 ** (n - 1)

  defp parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.map(&String.split(&1, ":"))
    |> Enum.map(&List.last/1)
    |> Enum.map(&String.split(&1, "|"))
    |> Enum.with_index(1)
    |> Enum.map(&(%{card_nr: &1 |> elem(1), winning_numbers: &1 |> elem(0) |> List.first |> parse_numbers, numbers: &1 |> elem(0) |> List.last |> parse_numbers}))
  end

  defp parse_numbers(input), do: Regex.scan(~r/\d+/, input) |> Enum.map(&hd/1) |> Enum.map(&String.to_integer/1)
end
