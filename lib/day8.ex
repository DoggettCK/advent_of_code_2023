defmodule Day8 do
  def part_one(input) do
    input
    |> build_instructions_and_network()
    |> traverse_network()
  end

  def part_two(input) do
    input
    |> build_instructions_and_network()
    |> traverse_ghosts()
  end

  defp build_instructions_and_network([instructions | network_lines]) do
    instruction_stream =
      instructions
      |> String.graphemes()
      |> Stream.cycle()

    network =
      Enum.reduce(network_lines, %{}, fn line, acc ->
        [[node], [left], [right]] = Regex.scan(~r/\w{3}/, line)

        Map.put(acc, node, %{left: left, right: right})
      end)

    {
      instruction_stream,
      network
    }
  end

  defp move(network, node, "L"), do: Map.get(network, node).left
  defp move(network, node, "R"), do: Map.get(network, node).right

  # Part 1
  defp traverse_network({instruction_stream, network}) do
    instruction_stream
    |> Enum.reduce_while({0, "AAA"}, fn instruction, {steps, last} ->
      case move(network, last, instruction) do
        "ZZZ" ->
          {:halt, steps + 1}

        next ->
          {:cont, {steps + 1, next}}
      end
    end)
  end

  # Part 2
  defp gcd(a, 0), do: a
  defp gcd(0, b), do: b
  defp gcd(a, b), do: gcd(b, rem(a, b))

  defp lcm(0, 0), do: 0
  defp lcm(a, b), do: round(a * b / gcd(a, b))

  defp find_lcm([single]), do: single

  defp find_lcm([a, b | rest]) do
    find_lcm([lcm(a, b) | rest])
  end

  defp traverse_ghosts({instruction_stream, network}) do
    start_nodes =
      network
      |> Map.keys()
      |> Enum.filter(&String.ends_with?(&1, "A"))

    start_nodes
    |> Enum.map(fn start ->
      instruction_stream
      |> Enum.reduce_while({0, start}, fn instruction, {steps, last} ->
        case move(network, last, instruction) do
          <<_::binary-size(2), "Z">> ->
            {:halt, steps + 1}

          next ->
            {:cont, {steps + 1, next}}
        end
      end)
    end)
    |> find_lcm()
  end
end
