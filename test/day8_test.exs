defmodule Day8Test do
  use ExUnit.Case
  import AdventOfCode2023.Test.Common

  test "part one example" do
    assert nil ==
             load_input(8, "example")
             |> Day8.part_one()
  end

  test "part one real" do
    assert nil ==
             load_input(8, "real")
             |> Day8.part_one()
  end

  test "part two example" do
    assert nil ==
             load_input(8, "example")
             |> Day8.part_two()
  end

  test "part two real" do
    assert nil ==
             load_input(8, "real")
             |> Day8.part_two()
  end
end
