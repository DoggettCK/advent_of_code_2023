defmodule Day20Test do
  use ExUnit.Case

  test "part one" do
    assert nil ==
             load_input(true)
             |> Day20.part_one()
  end

  test "part two" do
    assert nil ==
             load_input(true)
             |> Day20.part_two()
  end

  defp load_input(example \\ false) do
    input_file = if example, do: "example", else: "real"

    "test/fixtures/day20/#{input_file}"
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
