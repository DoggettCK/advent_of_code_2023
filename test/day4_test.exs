defmodule Day4Test do
  use ExUnit.Case

  test "part one" do
    assert 22193 ==
             load_input()
             |> Day4.part_one()
  end

  test "part two" do
    assert 5_625_994 ==
             load_input()
             |> Day4.part_two()
  end

  defp load_input(example \\ false) do
    input_file = if example, do: "example", else: "real"

    "test/fixtures/day4/#{input_file}"
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
