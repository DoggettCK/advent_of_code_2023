defmodule AdventOfCode2023.Test.Common do
  def load_input(day, example_or_real) do
    "test/fixtures/day#{day}/#{example_or_real}"
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
