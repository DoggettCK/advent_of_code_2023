defmodule Day5Test do
  use ExUnit.Case

  test "part one" do
    assert 240_320_250 ==
             load_input()
             |> Day5.part_one()
  end

  test "part two" do
    assert 677_937_579 ==
             load_input()
             |> Day5.part_two()
  end

  defp load_input(example \\ false) do
    input_file = if example, do: "example", else: "real"

    "test/fixtures/day5/#{input_file}"
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
