defmodule Day05 do

  def part1(input) do
    %{seeds: seeds, maps: maps} = parse(input)

    seeds
    |> Enum.map(fn seed -> Enum.reduce(maps, seed, &(apply_map(&1, &2))) end)
    |> Enum.min()
  end

  def part2(input) do
    %{seeds: seeds, maps: maps} = parse(input)

    seed_ranges =
      seeds
      |> Enum.chunk_every(2)
      |> Enum.map(&(%{seed_start: List.first(&1), seed_range: List.last(&1)}))

    maps_reverse = Enum.reverse(maps)

    find_lowest_in_range(1, maps_reverse, seed_ranges)
  end

  defp find_lowest_in_range(current, maps_reverse, seed_ranges) do
    seed = Enum.reduce(maps_reverse, current, &(apply_map_reverse(&1, &2)))

    if Enum.any?(seed_ranges, &(&1.seed_start <= seed and seed <= &1.seed_start + &1.seed_range - 1)) do
      current
    else
      find_lowest_in_range(current + 1, maps_reverse, seed_ranges)
    end
  end

  defp apply_map(map, number) do
    %{destination_start: destination_start, source_start: source_start} =
      Enum.find(map, %{destination_start: number, source_start: number}, fn x -> x.source_start <= number and number <= x.source_start + x.range_length - 1 end)

    destination_start - source_start + number
  end

  defp apply_map_reverse(map, number) do
    %{destination_start: destination_start, source_start: source_start} =
      Enum.find(map, %{destination_start: number, source_start: number}, fn x -> x.destination_start <= number and number <= x.destination_start + x.range_length - 1 end)

    source_start - destination_start + number
  end

  defp parse(input) do
    seeds =
      input
      |> String.split(~r/\R{2}/)
      |> List.first()
      |> then(&Regex.scan(~r/\d+/, &1))
      |> Enum.map(&hd/1)
      |> Enum.map(&String.to_integer/1)

    maps =
      input
      |> String.split(~r/\R{2}/)
      |> Enum.drop(1)
      |> Enum.map(&parse_map/1)

    %{seeds: seeds, maps: maps}
  end

  defp parse_map(map_input) do
    map_input
    |> String.split(~r/\R/)
    |> Enum.drop(1)
    |> Enum.map(fn x -> Regex.scan(~r/\d+/, x) |> Enum.map(&hd/1) |> Enum.map(&String.to_integer/1) end)
    |> Enum.map(fn x -> %{destination_start: Enum.at(x, 0), source_start: Enum.at(x, 1), range_length: Enum.at(x, 2)} end)
  end
end
