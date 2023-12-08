defmodule Day07 do

  def part1(input), do: solve(input, false)
  def part2(input), do: solve(input, true)

  defp solve(input, use_jokers) do
    input
    |> parse()
    |> Enum.sort(&compare(&1, &2, use_jokers))
    |> Enum.with_index(1)
    |> Enum.map(fn {%{bid: bid}, index} -> bid * index end)
    |> Enum.sum()
  end

  defp compare(%{hand: hand_one}, %{hand: hand_two}, use_jokers) do
    eval_func = if(use_jokers, do: &eval_hand_with_jokers(&1), else: &eval_hand(&1))

    score_one = eval_func.(hand_one)
    score_two = eval_func.(hand_two)

    if score_one == score_two do
      compare_by_order(hand_one, hand_two, use_jokers)
    else
      score_one < score_two
    end
  end

  defp compare_by_order(<<a>> <> r1, <<b>> <> r2, use_jokers) when a == b, do: compare_by_order(r1, r2, use_jokers)
  defp compare_by_order(<<a::binary-size(1)>> <> _, <<b::binary-size(1)>> <> _, use_jokers) do
    card_strength(a, use_jokers) < card_strength(b, use_jokers)
  end

  defp card_strength(card, use_jokers) do
    special_cards_strength = %{"A" => 14, "K" => 13, "Q" => 12, "J" => joker_strength(use_jokers), "T" => 10}

    case Map.fetch(special_cards_strength, card) do
      {:ok, value} -> value
      _ -> String.to_integer(card)
    end
  end

  defp joker_strength(true), do: 1
  defp joker_strength(false), do: 11

  defp eval_hand_with_jokers(hand) do
    hand
    |> get_combinations("")
    |> List.flatten()
    |> Enum.map(&eval_hand/1)
    |> Enum.max()
  end

  defp get_combinations("", start), do: [start]
  defp get_combinations("J" <> rest, start) do
    start <> rest
    |> String.graphemes()
    |> Enum.uniq()
    |> Enum.map(&get_combinations(rest, start <> &1))
  end
  defp get_combinations(<<a>> <> rest, start), do: get_combinations(rest, start <> <<a>>)

  defp eval_hand(hand) do
    card_count = hand
    |> String.graphemes()
    |> Enum.group_by(& &1)
    |> Enum.map(fn {a, b} -> %{card: a, count: Enum.count(b)} end)
    |> Enum.sort(fn %{count: c1}, %{count: c2} -> c1 > c2 end)

    case card_count do
      [%{count: 5}] -> 7
      [%{count: 4} | _ ] -> 6
      [%{count: 3}, %{count: 2}] -> 5
      [%{count: 3} | _ ] -> 4
      [%{count: 2}, %{count: 2}, _] -> 3
      [%{count: 2} | _ ] -> 2
      _ -> 1
    end
  end

  defp parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(& %{hand: Enum.at(&1, 0), bid: Enum.at(&1, 1) |> String.to_integer()})
  end
end
