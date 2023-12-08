defmodule Day15Test do
  use ExUnit.Case
  import AdventOfCode2023.Test.Common

  test "part one example" do
    assert nil ==
             load_input(15, "example")
             |> Day15.part_one()
  end

  test "part one real" do
    assert nil ==
             load_input(15, "real")
             |> Day15.part_one()
  end

  test "part two example" do
    assert nil ==
             load_input(15, "example")
             |> Day15.part_two()
  end

  test "part two real" do
    assert nil ==
             load_input(15, "real")
             |> Day15.part_two()
  end
end
