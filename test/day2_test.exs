defmodule Day2Test do
  use ExUnit.Case

  test "part one" do
    assert 2683 ==
      load_input()
      |> Day2.part_one()
  end

  test "part two" do
    assert 49710 ==
      load_input()
      |> Day2.part_two()
  end

  defp load_input(example \\ false) do
    input_file = if example, do: "example", else: "real"

    "test/fixtures/day2/#{input_file}"
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
