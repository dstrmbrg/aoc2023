defmodule Day08 do

  def part1(input) do
    {instructions, node_map} = parse(input)

    find_steps("AAA", instructions, node_map)
  end

  def part2(input) do
    {instructions, node_map} = parse(input)

    starting_nodes =
      node_map
      |> Enum.filter(fn {n, _} -> String.ends_with?(n, "A") end)
      |> Enum.map(fn {n, _} -> n end)

    starting_nodes
    |> Enum.map(&find_steps(&1, instructions, node_map))
    |> Enum.reduce(1, &Math.lcm(&1, &2))
  end

  defp find_steps(start, instructions, node_map) do
    instructions
    |> Stream.cycle()
    |> Enum.reduce_while({start, 0}, &travel_until_goal(&2, &1, node_map))
    |> elem(1)
  end

  defp travel_until_goal(ns = {<<_::binary-size(2)>> <> "Z", _}, _, _), do: {:halt, ns}
  defp travel_until_goal(current, instruction, node_map) do
    {:cont, travel(current, instruction, node_map)}
  end

  defp travel({current_node, steps}, instruction, node_map) do
    {node_map[current_node]|> travel(instruction), steps + 1}
  end
  defp travel(%{left: left_node}, "L"), do: left_node
  defp travel(%{right: right_node}, "R"), do: right_node

  defp parse(input) do
    parts = String.split(input, ~r/\R{2}/)

    instructions =
      parts
      |> hd()
      |> String.graphemes()

    node_map =
      parts
      |> List.last()
      |> String.split(~r/\R/)
      |> Enum.reduce(%{}, &Map.merge(&2, parse_node(&1)))

    {instructions, node_map}
  end

  defp parse_node(input) do
    <<node_name::binary-size(3)>>
      <> " = ("
      <> <<left_node::binary-size(3)>>
      <> ", "
      <> <<right_node::binary-size(3)>>
      <> ")" = input

    %{node_name => %{left: left_node, right: right_node}}
  end
end
