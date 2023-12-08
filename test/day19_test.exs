defmodule Day19Test do
  use ExUnit.Case
  import AdventOfCode2023.Test.Common

  test "part one example" do
    assert nil ==
             load_input(19, "example")
             |> Day19.part_one()
  end

  test "part one real" do
    assert nil ==
             load_input(19, "real")
             |> Day19.part_one()
  end

  test "part two example" do
    assert nil ==
             load_input(19, "example")
             |> Day19.part_two()
  end

  test "part two real" do
    assert nil ==
             load_input(19, "real")
             |> Day19.part_two()
  end
end
