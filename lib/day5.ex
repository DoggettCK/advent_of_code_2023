defmodule Day5 do
  def part_one(input) do
    input
    |> parse_almanac()
    |> find_locations_for_seeds()
    |> Enum.min()
  end

  def part_two(input) do
    input
    |> parse_almanac()
    |> find_locations_for_seed_ranges()
    |> Enum.map(&elem(&1, 0))
    |> Enum.min()
  end

  # Common
  defp parse_almanac(lines) do
    parse_almanac(lines, :start, %{})
  end

  defp parse_almanac([], _state, almanac), do: almanac

  defp parse_almanac(["\n" | rest], state, almanac) do
    parse_almanac(rest, state, almanac)
  end

  defp parse_almanac(["seeds: " <> seeds | rest], _state, almanac) do
    seed_list = Common.string_to_integers(seeds)

    seed_ranges =
      seed_list
      |> Enum.chunk_every(2)
      |> Enum.map(fn [start, range] -> {start, start + range - 1} end)

    updated =
      almanac
      |> Map.put(:seeds, seed_list)
      |> Map.put(:seed_ranges, seed_ranges)

    parse_almanac(rest, :seeds, updated)
  end

  defp parse_almanac(["seed-to-soil map:" <> _ | rest], _state, almanac) do
    parse_almanac(rest, :seed_to_soil, almanac)
  end

  defp parse_almanac(["soil-to-fertilizer map:" <> _ | rest], _state, almanac) do
    parse_almanac(rest, :soil_to_fertilizer, almanac)
  end

  defp parse_almanac(["fertilizer-to-water map:" <> _ | rest], _state, almanac) do
    parse_almanac(rest, :fertilizer_to_water, almanac)
  end

  defp parse_almanac(["water-to-light map:" <> _ | rest], _state, almanac) do
    parse_almanac(rest, :water_to_light, almanac)
  end

  defp parse_almanac(["light-to-temperature map:" <> _ | rest], _state, almanac) do
    parse_almanac(rest, :light_to_temperature, almanac)
  end

  defp parse_almanac(["temperature-to-humidity map:" <> _ | rest], _state, almanac) do
    parse_almanac(rest, :temperature_to_humidity, almanac)
  end

  defp parse_almanac(["humidity-to-location map:" <> _ | rest], _state, almanac) do
    parse_almanac(rest, :humidity_to_location, almanac)
  end

  defp parse_almanac([line | rest], state, almanac) do
    [dest, src, range] = Common.string_to_integers(line)

    interval = %{
      dest: dest,
      src: src,
      src_stop: src + range - 1,
      shift: dest - src,
      range: range
    }

    updated = Map.update(almanac, state, [interval], &[interval | &1])

    parse_almanac(rest, state, updated)
  end

  defp parse_almanac(_lines, _state, almanac) do
    almanac
  end

  # Day 1
  defp find_locations_for_seeds(almanac) do
    Enum.map(almanac.seeds, fn seed_id -> seed_to_location(seed_id, almanac) end)
  end

  defp seed_to_location(seed_id, almanac) do
    seed_id
    |> source_to_destination(almanac.seed_to_soil)
    |> source_to_destination(almanac.soil_to_fertilizer)
    |> source_to_destination(almanac.fertilizer_to_water)
    |> source_to_destination(almanac.water_to_light)
    |> source_to_destination(almanac.light_to_temperature)
    |> source_to_destination(almanac.temperature_to_humidity)
    |> source_to_destination(almanac.humidity_to_location)
  end

  defp source_to_destination(position, []), do: position

  defp source_to_destination(position, [%{src: src, src_stop: src_stop, shift: shift} | rest]) do
    if position in src..src_stop do
      position + shift
    else
      source_to_destination(position, rest)
    end
  end

  # Day 2
  defp find_locations_for_seed_ranges(almanac) do
    almanac.seed_ranges
    |> Enum.flat_map(&transform_ranges(&1, almanac.seed_to_soil))
    |> Enum.flat_map(&transform_ranges(&1, almanac.soil_to_fertilizer))
    |> Enum.flat_map(&transform_ranges(&1, almanac.fertilizer_to_water))
    |> Enum.flat_map(&transform_ranges(&1, almanac.water_to_light))
    |> Enum.flat_map(&transform_ranges(&1, almanac.light_to_temperature))
    |> Enum.flat_map(&transform_ranges(&1, almanac.temperature_to_humidity))
    |> Enum.flat_map(&transform_ranges(&1, almanac.humidity_to_location))
  end

  def transform_ranges({min, max} = input_range, mapping_ranges) do
    min_src = Enum.min_by(mapping_ranges, & &1.src).src
    max_src = Enum.max_by(mapping_ranges, & &1.src_stop).src_stop

    if max < min_src or min > max_src do
      List.wrap(input_range)
    else
      split_ranges(input_range, min_src, max_src, mapping_ranges, [])
    end
  end

  def split_ranges({min, max}, min_src, max_src, mapping_ranges, acc) do
    acc
    |> add_left_non_overlapping(min, min_src)
    |> add_right_non_overlapping(max, max_src)
    |> add_intersecting_ranges(max(min, min_src), min(max, max_src), mapping_ranges)
  end

  def add_left_non_overlapping(acc, min, min_src) when min < min_src,
    do: [{min, min_src - 1} | acc]

  def add_left_non_overlapping(acc, _, _), do: acc

  def add_right_non_overlapping(acc, max, max_src) when max > max_src,
    do: [{max_src + 1, max} | acc]

  def add_right_non_overlapping(acc, _, _), do: acc

  def add_intersecting_ranges(acc, min, max, mapping_ranges) do
    Enum.reduce(mapping_ranges, acc, &build_intersecting_range(&1, &2, min, max, mapping_ranges))
  end

  defp build_intersecting_range(%{src_stop: src_stop}, acc, min, _, _) when min > src_stop,
    do: acc

  defp build_intersecting_range(%{src: src, src_stop: src_stop, shift: shift}, acc, min, max, _)
       when min >= src and max < src_stop + 1 do
    [{min + shift, max + shift} | acc]
  end

  defp build_intersecting_range(
         %{src: src, src_stop: src_stop} = input,
         acc,
         min,
         max,
         mapping_ranges
       )
       when min >= src and max > src_stop do
    %{dest: dest, range: range, shift: shift} = input

    mapping_ranges
    |> Enum.reject(fn
      ^input -> true
      _ -> false
    end)
    |> then(&add_intersecting_ranges([{min + shift, dest + range} | acc], src + range, max, &1))
  end

  defp build_intersecting_range(_, acc, _, _, _) do
    acc
  end
end
