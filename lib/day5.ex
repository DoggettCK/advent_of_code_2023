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
    seed_list = line_to_integers(seeds)

    seed_ranges =
      seed_list
      |> Enum.chunk_every(2)
      |> Enum.map(fn [start, count] -> [start, start + count - 1] end)

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
    [dest, src, count] = line_to_integers(line)

    interval = %{
      dest: [dest, dest + count - 1],
      src: [src, src + count - 1]
    }

    updated = Map.update(almanac, state, [interval], &[interval | &1])

    parse_almanac(rest, state, updated)
  end

  defp parse_almanac(_lines, _state, almanac) do
    almanac
  end

  defp line_to_integers(line) do
    ~r/\d+/
    |> Regex.scan(line)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end

  defp source_to_destination(id, []), do: id

  defp source_to_destination(id, [%{dest: [dest_start, _], src: [src_start, src_stop]} | rest]) do
    if id in src_start..src_stop do
      dest_start - src_start + id
    else
      source_to_destination(id, rest)
    end
  end

  # Day 1
  defp find_locations_for_seeds(almanac) do
    Enum.map(almanac.seeds, fn seed_id -> seed_to_location(seed_id, almanac) end)
  end

  defp seed_to_location(seed_id, almanac) do
    seed_id
    |> get_soil_from_seed(almanac)
    |> get_fertilizer_from_soil(almanac)
    |> get_water_from_fertilizer(almanac)
    |> get_light_from_water(almanac)
    |> get_temperature_from_light(almanac)
    |> get_humidity_from_temperature(almanac)
    |> get_location_from_humidity(almanac)
  end

  defp get_soil_from_seed(id, almanac) do
    source_to_destination(id, almanac.seed_to_soil)
  end

  defp get_fertilizer_from_soil(id, almanac) do
    source_to_destination(id, almanac.soil_to_fertilizer)
  end

  defp get_water_from_fertilizer(id, almanac) do
    source_to_destination(id, almanac.fertilizer_to_water)
  end

  defp get_light_from_water(id, almanac) do
    source_to_destination(id, almanac.water_to_light)
  end

  defp get_temperature_from_light(id, almanac) do
    source_to_destination(id, almanac.light_to_temperature)
  end

  defp get_humidity_from_temperature(id, almanac) do
    source_to_destination(id, almanac.temperature_to_humidity)
  end

  defp get_location_from_humidity(id, almanac) do
    source_to_destination(id, almanac.humidity_to_location)
  end

  # Day 2
  defp find_locations_for_seed_ranges(almanac) do
    # NOTE: Currently incorrect, but giving up for now
    almanac.seed_ranges
    |> Enum.map(&seed_range_to_location(&1, almanac))
    |> List.flatten()
    |> Enum.take_every(2)
    |> Enum.min()
  end

  defp seed_range_to_location(seed_range, almanac) do
    seed_range
    |> List.wrap()
    |> get_soil_ranges_from_seed(almanac)
    |> get_fertilizer_ranges_from_soil(almanac)
    |> get_water_ranges_from_fertilizer(almanac)
    |> get_light_ranges_from_water(almanac)
    |> get_temperature_ranges_from_light(almanac)
    |> get_humidity_ranges_from_temperature(almanac)
    |> get_location_ranges_from_humidity(almanac)
  end

  defp get_soil_ranges_from_seed(range, almanac) do
    split_and_transform_ranges(range, almanac.seed_to_soil)
  end

  defp get_fertilizer_ranges_from_soil(range, almanac) do
    split_and_transform_ranges(range, almanac.soil_to_fertilizer)
  end

  defp get_water_ranges_from_fertilizer(range, almanac) do
    split_and_transform_ranges(range, almanac.fertilizer_to_water)
  end

  defp get_light_ranges_from_water(range, almanac) do
    split_and_transform_ranges(range, almanac.water_to_light)
  end

  defp get_temperature_ranges_from_light(range, almanac) do
    split_and_transform_ranges(range, almanac.light_to_temperature)
  end

  defp get_humidity_ranges_from_temperature(range, almanac) do
    split_and_transform_ranges(range, almanac.temperature_to_humidity)
  end

  defp get_location_ranges_from_humidity(range, almanac) do
    split_and_transform_ranges(range, almanac.humidity_to_location)
  end

  defp inspect_ranges(list, label) do
    IO.inspect(length(list), label: "Length", charlists: :as_lists)
    IO.inspect(list, label: label, charlists: :as_lists)
  end

  defp split_and_transform_ranges(seed_range, mapped_ranges) do
    Enum.map(mapped_ranges, fn mapped_range ->
      split_and_transform_range(seed_range, mapped_range)
    end)
    |> List.flatten()
    |> Enum.chunk_every(2)
    |> Enum.uniq()
  end

  defp split_and_transform_range(range, mapped_range) do
    [range_start, range_stop | _] = List.flatten(range)

    %{
      src: [src_start, src_stop],
      dest: [dest_start, dest_stop]
    } = mapped_range

    cond do
      range_stop < src_start ->
        # Range entirely before mapped, no transform
        [range_start, range_stop]

      range_start > src_stop ->
        # Range entirely after mapped, no transform
        [range_start, range_stop]

      range_start < src_start and range_stop > src_stop ->
        # Range entirely covers source
        # No transform for parts before and after
        # Transform middle, which is just entire src->dest
        [
          [range_start, src_start - 1],
          [dest_start, dest_stop],
          [src_stop + 1, range_stop]
        ]

      range_start >= src_start and range_stop <= src_stop ->
        # Range entirely inside source
        # Transform with offset
        [range_start + dest_start - src_start, range_stop + dest_start - src_start]

      range_start < src_start and range_stop in src_start..src_stop ->
        # Range overlaps source on left, starting before source start, ending inside source
        # before or at source stop
        # Range before source not transformed
        # Overlapping range transformed
        [
          [range_start, src_start - 1],
          [dest_start, range_stop + dest_start - src_start]
        ]

      range_start in src_start..src_stop and range_stop > src_stop ->
        # Range overlaps source on right, starting inside source, ending after source stop
        # before or at source stop
        # Range before source not transformed
        # Overlapping range transformed
        [
          [range_start + dest_start - src_start, dest_stop],
          [src_stop + 1, range_stop]
        ]
    end
  end
end
