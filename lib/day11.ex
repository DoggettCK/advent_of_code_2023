defmodule Day11 do
  def part_one(input) do
    input
    |> build_galaxy_map(2)
    |> calculate_combined_distances()
  end

  def part_two(input) do
    input
    |> build_galaxy_map(1_000_000)
    |> calculate_combined_distances()
  end

  defp build_galaxy_map(input, expansion_rate) do
    width = input |> hd() |> String.length()
    height = input |> length()

    initial_galaxy = %{
      width: width,
      height: height,
      galaxies: %{},
      empty_rows: MapSet.new(0..(height - 1)),
      empty_cols: MapSet.new(0..(width - 1))
    }

    input
    |> Enum.with_index()
    |> Enum.reduce(initial_galaxy, &add_galaxy_row/2)
    |> expand_galaxy(expansion_rate)
  end

  defp add_galaxy_row({line, row}, map) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(map, fn
      {"#", col}, acc ->
        acc
        |> put_in([:galaxies, {col, row}], "#")
        |> Map.update(:empty_rows, MapSet.new(), &MapSet.delete(&1, row))
        |> Map.update(:empty_cols, MapSet.new(), &MapSet.delete(&1, col))

      _, acc ->
        acc
    end)
  end

  defp expand_galaxy(map, expansion_rate) do
    %{
      width: width,
      height: height,
      empty_cols: empty_cols,
      empty_rows: empty_rows,
      galaxies: galaxies
    } = map

    rows_to_replace = MapSet.size(empty_rows)
    cols_to_replace = MapSet.size(empty_cols)

    new_width = cols_to_replace * (width + expansion_rate - 1)
    new_height = rows_to_replace * (height + expansion_rate - 1)

    expanded_galaxies =
      galaxies
      |> Map.new(fn {{col, row}, "#"} ->
        rows_to_shift =
          empty_rows
          |> MapSet.filter(&(&1 < row))
          |> MapSet.size()
          |> Kernel.*(expansion_rate - 1)

        {{col, row + rows_to_shift}, "#"}
      end)
      |> Map.new(fn {{col, row}, "#"} ->
        cols_to_shift =
          empty_cols
          |> MapSet.filter(&(&1 < col))
          |> MapSet.size()
          |> Kernel.*(expansion_rate - 1)

        {{col + cols_to_shift, row}, "#"}
      end)

    %{
      map
      | width: new_width,
        height: new_height,
        empty_cols: MapSet.new(),
        empty_rows: MapSet.new(),
        galaxies: expanded_galaxies
    }
  end

  defp calculate_combined_distances(map) do
    galaxies =
      map
      |> Map.get(:galaxies)
      |> Map.keys()

    galaxies
    |> Enum.reduce(%{}, fn galaxy, distance_map ->
      galaxies
      |> Enum.into(distance_map, fn other_galaxy ->
        {
          Enum.sort([galaxy, other_galaxy]),
          manhattan_distance(galaxy, other_galaxy)
        }
      end)
    end)
    |> Map.values()
    |> Enum.sum()
  end

  defp manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end
end
