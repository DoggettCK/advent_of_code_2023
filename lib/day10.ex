defmodule Day10 do
  def part_one(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce(%{}, &build_grid/2)
    |> calculate_start_neighbors()
    |> flood_fill()
    |> find_furthest()
  end

  def part_two(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce(%{}, &build_grid/2)
    |> calculate_start_neighbors()
    |> flood_fill()
    |> hd()
    |> calculate_area()
  end

  # Part 1
  # Set visited = ['S' coords], make a distance map by following pipes, adding to visited, incrementing distance by 1 for each one
  # When you reach 'S' again, done, find point where dist(x, y) from S is equal in both maps for same point
  defp build_grid({line, row}, acc) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(acc, fn {char, col}, inner_acc ->
      build_cell(char, col, row, inner_acc)
    end)
  end

  defp build_cell("S", col, row, acc) do
    acc
    |> Map.put(:start, {col, row})
    |> Map.put({col, row}, [])
  end

  defp build_cell(char, col, row, acc) do
    char
    |> neighbors(col, row)
    |> then(&Map.put(acc, {col, row}, &1))
  end

  defp neighbors("|", col, row), do: [{col, row - 1}, {col, row + 1}]
  defp neighbors("-", col, row), do: [{col - 1, row}, {col + 1, row}]
  defp neighbors("L", col, row), do: [{col, row - 1}, {col + 1, row}]
  defp neighbors("J", col, row), do: [{col, row - 1}, {col - 1, row}]
  defp neighbors("7", col, row), do: [{col - 1, row}, {col, row + 1}]
  defp neighbors("F", col, row), do: [{col + 1, row}, {col, row + 1}]
  defp neighbors(_, _, _), do: []

  defp calculate_start_neighbors(grid) do
    {col, row} = Map.get(grid, :start)

    [
      {col - 1, row},
      {col + 1, row},
      {col, row - 1},
      {col, row + 1}
    ]
    |> Enum.filter(fn {n_col, n_row} ->
      {col, row} in Map.get(grid, {n_col, n_row}, [])
    end)
    |> then(&Map.put(grid, {col, row}, &1))
  end

  defp flood_fill(grid) do
    start = Map.get(grid, :start)
    visited = %{start => 0}
    [left, right] = Map.get(grid, start)

    left_visited = visit_neighbors(left, 1, visited, grid)
    right_visited = visit_neighbors(right, 1, visited, grid)

    [left_visited, right_visited]
  end

  defp visit_neighbors(cell, dist, visited, grid) do
    new_visited = Map.update(visited, cell, dist, &min(&1, dist))

    grid
    |> Map.get(cell)
    |> Enum.reject(&Map.has_key?(visited, &1))
    |> Enum.reduce(new_visited, &visit_neighbors(&1, dist + 1, &2, grid))
  end

  defp find_furthest([left, right]) do
    ms_one =
      left
      |> Enum.map(fn {{x, y}, d} -> {x, y, d} end)
      |> MapSet.new()

    ms_two =
      right
      |> Enum.map(fn {{x, y}, d} -> {x, y, d} end)
      |> MapSet.new()

    ms_one
    |> MapSet.intersection(ms_two)
    |> Enum.max_by(fn {_, _, d} -> d end)
    |> elem(2)
  end

  # Part 2
  defp calculate_area(points_list) do
    indexed = Enum.into(points_list, %{}, fn {k, v} -> {v, k} end)

    loop_length = map_size(indexed)

    loop_area =
      0..(loop_length - 1)
      |> Enum.chunk_every(2, 1, Stream.cycle([0]))
      |> Enum.reduce(0, fn [current, next], acc ->
        {current_x, current_y} = Map.get(indexed, current)
        {next_x, next_y} = Map.get(indexed, next)

        acc + (current_x * next_y - current_y * next_x)
      end)
      |> abs()
      |> div(2)

    loop_area - div(loop_length, 2) + 1
  end
end
