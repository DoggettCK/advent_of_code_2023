defmodule Day3 do
  def part_one(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce(%{adjacent: %{}, symbols: []}, &build_adjacency_map/2)
    |> get_part_numbers()
  end

  def part_two(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce(%{adjacent: %{}, symbols: []}, &build_adjacency_map/2)
    |> get_gears()
  end

  defp build_adjacency_map({line, row}, map) do
    symbols =
      Regex.scan(~r/[^.0-9]/, line, return: :index)
      |> List.flatten()
      |> Enum.map(fn {col, _} -> {col, row, String.slice(line, col, 1)} end)

    rect_to_part =
      Regex.scan(~r/\d+/, line, return: :index)
      |> List.flatten()
      |> Enum.map(fn {col, length} ->
        {
          {col - 1, row - 1, col + length, row + 1},
          line
          |> String.slice(col, length)
          |> String.to_integer()
        }
      end)
      |> Enum.into(%{})

    %{map | adjacent: Map.merge(map.adjacent, rect_to_part), symbols: map.symbols ++ symbols}
  end

  defp get_part_numbers(%{adjacent: adjacent, symbols: symbols}) do
    symbols
    |> Enum.map(fn symbol_point ->
      Map.filter(adjacent, fn {rect, _} ->
        point_in_rect?(symbol_point, rect)
      end)
    end)
    |> Enum.map(&Map.values/1)
    |> List.flatten()
    |> Enum.sum()
  end

  defp get_gears(%{adjacent: adjacent, symbols: symbols}) do
    symbols
    |> Enum.filter(fn
      {_, _, "*"} -> true
      _ -> false
    end)
    |> Enum.map(fn symbol_point ->
      adjacent
      |> Map.filter(fn {rect, _} ->
        point_in_rect?(symbol_point, rect)
      end)
    end)
    |> Enum.filter(&(map_size(&1) == 2))
    |> Enum.map(fn map -> map |> Map.values() |> Enum.product() end)
    |> Enum.sum()
  end

  defp point_in_rect?({col, row, _}, {c1, r1, c2, r2}) do
    col in c1..c2 and row in r1..r2
  end
end
