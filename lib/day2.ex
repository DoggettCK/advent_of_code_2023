defmodule Day2 do
  @bag %{red: 12, green: 13, blue: 14}

  def part_one(input) do
    input
    |> Enum.map(&parse_game/1)
    |> Enum.filter(&game_valid?/1)
    |> Enum.map(&(&1.id))
    |> Enum.sum()
  end

  def part_two(input) do
    input
    |> Enum.map(&parse_game/1)
    |> Enum.map(&minimum_set_power/1)
    |> Enum.sum()
  end

  defp parse_game(line) do
    [[id_str, play_lines]] =
      Regex.scan(~r/Game (\d+): (.*)/, line, capture: :all_but_first)

    %{
      id: String.to_integer(id_str),
      plays: parse_plays(play_lines)
    }
    |> find_minimums()
  end

  defp parse_plays(line) do
    line
    |> String.split("; ", trim: true)
    |> Enum.map(&parse_play/1)
  end

  defp parse_play(play) do
    Regex.scan(~r/(\d+)\s+(green|red|blue)/, play, capture: :all_but_first)
    |> Enum.into(%{}, fn [count, color] ->
      {String.to_existing_atom(color), String.to_integer(count)}
    end)
  end

  defp game_valid?(game) do
    Enum.all?(game.plays, &play_valid?/1)
  end

  defp play_valid?(play) do
    @bag
    |> Map.merge(play, fn _k, v1, v2 -> v1 - v2 end)
    |> Map.values()
    |> Enum.all?(fn count -> count >= 0 end)
  end

  defp find_minimums(game) do
    minimums =
      game.plays
      |> Enum.reduce(%{red: 0, green: 0, blue: 0}, fn play, acc ->
        Map.merge(acc, play, fn _k, v1, v2 -> max(v1, v2) end)
      end)

    Map.put(game, :minimums, minimums)
  end

  defp minimum_set_power(game) do
    game.minimums
    |> Map.values()
    |> Enum.product()
  end
end
