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
  defp interval(start, count) do
    start..(start + count - 1)
  end

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
      |> Enum.map(fn [start, count] -> interval(start, count) end)

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
    [dest, src, count] = Common.string_to_integers(line)

    interval = %{
      dest: dest,
      src: src,
      range: count,
      shift: dest - src,
      transform: fn id ->
        if id in interval(src, count) do
          {:ok, id + dest - src}
        else
          :out_of_range
        end
      end
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

  defp source_to_destination(position, [%{transform: transform} | rest]) do
    case transform.(position) do
      {:ok, transformed} ->
        transformed

      :out_of_range ->
        source_to_destination(position, rest)
    end
  end

  # Day 2
  defp find_locations_for_seed_ranges(_almanac) do
  end
end
