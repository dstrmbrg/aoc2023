defmodule Mix.Tasks.Aoc2023.Solve do
  use Mix.Task

  @impl Mix.Task
  def run(args) do

    use_test_input = Enum.member?(args, "--test")
    day = get_day(args)
    input = InputReader.read(day, use_test_input)
    module = "Elixir.Day#{day |> Integer.to_string() |> String.pad_leading(2, "0")}" |> String.to_existing_atom()

    p1 = apply(module, :part1, [input])
    p2 = apply(module, :part2, [input])

    IO.puts("""
    ----------------------------------------
    Part one:
    #{p1}

    Part two:
    #{p2}
    """)
  end

  defp get_day(args) do
    case Enum.find(args, &(Integer.parse(&1) != :error)) do
      nil -> raise "Day argument not included."
      day -> String.to_integer(day)
    end
  end
end
