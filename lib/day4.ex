defmodule Day4 do
  @re_number ~r/\d+/

  def part_one(input) do
    input
    |> Enum.map(&score_game/1)
    |> Enum.map(fn {_, c} -> score_matches(c) end)
    |> Enum.sum()
  end

  def part_two(input) do
    input
    |> Enum.map(&score_game/1)
    |> Enum.into(%{}, fn {k, v} -> {k, {v, 1}} end)
    |> count_tickets()
  end

  defp score_game(line) do
    [card_id, winning, yours] = Regex.split(~r/[:|]/, line)

    id =
      @re_number
      |> Regex.scan(card_id)
      |> hd()
      |> hd()
      |> String.to_integer()

    winning_numbers =
      @re_number
      |> Regex.scan(winning)
      |> Enum.into(%{}, fn [x] -> {x, true} end)

    matching_numbers =
      @re_number
      |> Regex.scan(yours)
      |> Enum.filter(fn [x] -> Map.has_key?(winning_numbers, x) end)

    {id, length(matching_numbers)}
  end

  defp score_matches(0), do: 0
  defp score_matches(count), do: 2 ** (count - 1)

  defp count_tickets(map) do
    max_id =
      map
      |> Map.keys()
      |> Enum.max()

    1..max_id
    |> Enum.reduce(map, fn id, acc ->
      {count, copies} = Map.get(acc, id)

      if count > 0 do
        children_to_update =
          (id + 1)..(id + count)
          |> Enum.to_list()

        updated_children =
          acc
          |> Map.take(children_to_update)
          |> Map.new(fn {child_id, {child_count, child_copies}} ->
            {child_id, {child_count, child_copies + copies}}
          end)

        Map.merge(acc, updated_children)
      else
        acc
      end
    end)
    |> Map.values()
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end
end
