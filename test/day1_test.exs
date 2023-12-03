defmodule Day1Test do
  use ExUnit.Case

  test "part one" do
    assert 55538 ==
             load_input()
             |> Day1.part_one()
  end

  test "part two" do
    assert 54875 ==
             load_input()
             |> Day1.part_two()
  end

  defp load_input(example \\ false) do
    input_file = if example, do: "example", else: "real"

    "test/fixtures/day1/#{input_file}"
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
