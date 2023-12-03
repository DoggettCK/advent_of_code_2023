defmodule Day3Test do
  use ExUnit.Case

  test "part one" do
    assert 514_969 ==
             load_input()
             |> Day3.part_one()
  end

  test "part two" do
    assert 78_915_902 ==
             load_input(false)
             |> Day3.part_two()
  end

  defp load_input(example \\ false) do
    input_file = if example, do: "example", else: "real"

    "test/fixtures/day3/#{input_file}"
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
