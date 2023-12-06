defmodule Day02 do

  def part1(input) do
    input
    |> parse
    |> Enum.filter(fn game -> game.sets |> Enum.all?(&set_is_valid?/1) end)
    |> Enum.map(&(&1.id))
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse
    |> Enum.map(&get_power/1)
    |> Enum.sum()

  end

  defp get_power(game) do

    max_red = game.sets |> List.flatten |> Enum.filter(&(&1.color == "red")) |> Enum.map(&(&1.amount)) |> Enum.max()
    max_green = game.sets |> List.flatten |> Enum.filter(&(&1.color == "green")) |> Enum.map(&(&1.amount)) |> Enum.max()
    max_blue = game.sets |> List.flatten |> Enum.filter(&(&1.color == "blue")) |> Enum.map(&(&1.amount)) |> Enum.max()

    max_red * max_green * max_blue
  end

  defp set_is_valid?(set) do
    set
    |> Enum.all?(&(amount_is_valid?(&1.color, &1.amount)))
  end

  defp amount_is_valid?("red", amount), do: amount <= 12
  defp amount_is_valid?("green", amount), do: amount <= 13
  defp amount_is_valid?("blue", amount), do: amount <= 14

  defp parse(input), do: input |> String.split(~r/\R/) |> Enum.map(&parse_game/1)
  defp parse_game(game_string) do
    game_parts = game_string |> String.split(":")

    %{
      id: game_parts
      |> hd
      |> String.split(" ")
      |> List.last()
      |> String.to_integer(),
      sets: game_parts
      |> List.last()
      |> parse_sets()
    }

  end

  defp parse_sets(rounds_string) do
    rounds_string
    |> String.split(";")
    |> Enum.map(&parse_cubes/1)
  end

  defp parse_cubes(cubes_string) do
    cubes_string
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_cube/1)
  end

  defp parse_cube(cube_string) do
    cube_parts = String.split(cube_string, " ")

    %{
      amount: cube_parts |> hd |> String.to_integer(),
      color: cube_parts |> List.last()
    }
  end


end
