defmodule Day6 do
  def part_one(input) do
    input
    |> Enum.map(&Common.string_to_integers/1)
    |> Enum.zip()
    |> Enum.map(&ways_to_win/1)
    |> Enum.product()
  end

  def part_two(input) do
    input
    |> Enum.map(&Regex.replace(~r/\s+/, &1, ""))
    |> part_one()
  end

  defp ways_to_win({time, record}) do
    [_a, b, c] = [1, -time, record]

    disc = :math.sqrt(b * b - 4 * c)

    [first, second] =
      [:math.floor((-b - disc) / 2), :math.ceil((-b + disc) / 2)]
      |> Enum.map(&round/1)

    second - first - 1
  end
end
