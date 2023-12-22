defmodule Day12 do
  def part_one(input) do
    input
    |> Stream.map(&String.split/1)
    |> Stream.map(fn [springs, counts] ->
      springs
      |> String.graphemes()
      |> count(Common.string_to_integers(counts))
    end)
    |> Enum.to_list()
    |> Enum.sum()
  end

  def part_two(input) do
    input
    |> Stream.map(&String.split/1)
    |> Stream.map(fn [springs, counts] ->
      duplicated_springs =
        springs
        |> String.graphemes()
        |> List.duplicate(5)
        |> Enum.intersperse("?")
        |> List.flatten()

      duplicated_counts =
        counts
        |> Common.string_to_integers()
        |> List.duplicate(5)
        |> List.flatten()

      count(duplicated_springs, duplicated_counts)
    end)
    |> Enum.to_list()
    |> Enum.sum()
  end

  defp cache_get(key) do
    Cachex.get(:day12, key)
  end

  defp cache_put(key, value) do
    {:ok, true} = Cachex.put(:day12, key, value)

    value
  end

  defp count([], []), do: 1
  defp count([], _), do: 0

  defp count(springs, []) do
    if Enum.member?(springs, "#"), do: 0, else: 1
  end

  defp count([next | _] = springs, counts) do
    cache_key = {springs, counts}

    case cache_get(cache_key) do
      {:ok, nil} ->
        result = skip_unplaceable(springs, counts)

        case next do
          "#" ->
            result + place_and_count(springs, counts)

          "?" ->
            result + place_and_count(springs, counts)

          _ ->
            result
        end
        |> then(&cache_put(cache_key, &1))

      {:ok, value} ->
        value
    end
  end

  defp skip_unplaceable(["." | springs], counts), do: count(springs, counts)
  defp skip_unplaceable(["?" | springs], counts), do: count(springs, counts)
  defp skip_unplaceable(_, _), do: 0

  defp place_and_count(springs, [count | _]) when count > length(springs), do: 0

  defp place_and_count(springs, [count | _] = counts) do
    cond do
      springs |> Enum.take(count) |> Enum.member?(".") ->
        0

      count == length(springs) ->
        count_sublist(springs, counts)

      Enum.at(springs, count) != "#" ->
        count_sublist(springs, counts)

      true ->
        0
    end
  end

  defp count_sublist(springs, [count | counts]) do
    springs
    |> Enum.slice((count + 1)..-1)
    |> count(counts)
  end
end
