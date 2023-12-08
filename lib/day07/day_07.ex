defmodule Day07 do

  def part1(input), do: solve(input, false)
  def part2(input), do: solve(input, true)

  defp solve(input, enhance_hands) do
    input
    |> parse()
    |> Enum.sort(&compare(&1, &2, enhance_hands))
    |> Enum.with_index(1)
    |> Enum.map(fn {%{bid: bid}, index} -> bid * index end)
    |> Enum.sum()
  end

  defp compare(%{hand: hand_one}, %{hand: hand_two}, enhance_hands) do
    score_one = eval_hand(hand_one, enhance_hands)
    score_two = eval_hand(hand_two, enhance_hands)

    if score_one == score_two do
      compare_by_order(hand_one, hand_two, enhance_hands)
    else
      score_one < score_two
    end
  end

  defp compare_by_order(<<a>> <> r1, <<b>> <> r2, enhance_hands) when a == b, do: compare_by_order(r1, r2, enhance_hands)
  defp compare_by_order(<<a::binary-size(1)>> <> _, <<b::binary-size(1)>> <> _, enhance_hands) do
    card_strength(a, enhance_hands) < card_strength(b, enhance_hands)
  end

  defp card_strength(card, enhance_hands) do
    special_cards_strength = %{"A" => 14, "K" => 13, "Q" => 12, "J" => joker_strength(enhance_hands), "T" => 10}

    case Map.fetch(special_cards_strength, card) do
      {:ok, value} -> value
      _ -> String.to_integer(card)
    end
  end

  defp joker_strength(true), do: 1
  defp joker_strength(false), do: 11

  defp eval_hand(hand, true) do
    hand
    |> enhance_hand()
    |> eval_hand(false)
  end
  defp eval_hand(hand, false) do
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

  defp enhance_hand(hand) do
    if String.contains?(hand, "J") do
      replace_with =
        hand
        |> String.graphemes()
        |> Enum.filter(& &1 != "J")
        |> Enum.group_by(& &1)
        |> Enum.max_by(fn {_, x} -> Enum.count(x) end, fn -> {"A", 0} end)
        |> elem(0)

      String.replace(hand, "J", replace_with)
    else
      hand
    end
  end

  defp parse(input) do
    input
    |> String.split(~r/\R/)
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(& %{hand: Enum.at(&1, 0), bid: Enum.at(&1, 1) |> String.to_integer()})
  end
end
