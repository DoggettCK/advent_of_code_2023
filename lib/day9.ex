defmodule Day9 do
  def part_one(input) do
    input
    |> Enum.map(&extrapolate/1)
    |> Enum.sum()
  end

  def part_two(input) do
    input
    |> Enum.map(&extrapolate_backwards/1)
    |> Enum.sum()
  end

  # Part 1
  defp extrapolate(line) do
    line
    |> Common.string_to_integers()
    |> Enum.reverse()
    |> make_subtractions([])
    |> make_extrapolations()
  end

  defp make_subtractions(list, acc) do
    next_list =
      list
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] -> a - b end)

    case Enum.uniq(next_list) do
      [0] ->
        [list | acc]

      _ ->
        make_subtractions(next_list, [list | acc])
    end
  end

  defp make_extrapolations([[result | _]]), do: result

  defp make_extrapolations([[inc | _], [acc | _] = next | rest]) do
    make_extrapolations([[acc + inc | next] | rest])
  end

  # Day 2
  defp extrapolate_backwards(line) do
    line
    |> Common.string_to_integers()
    |> make_subtractions([])
    |> make_extrapolations()
  end
end
