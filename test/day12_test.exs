defmodule Day12Test do
  use ExUnit.Case
  import AdventOfCode2023.Test.Common

  test "part one example" do
    assert 21 ==
             load_input(12, "example")
             |> Day12.part_one()
  end

  test "part one real" do
    assert 7344 ==
             load_input(12, "real")
             |> Day12.part_one()
  end

  test "part two example" do
    assert 525_152 ==
             load_input(12, "example")
             |> Day12.part_two()
  end

  test "part two real" do
    assert 1_088_006_519_007 ==
             load_input(12, "real")
             |> Day12.part_two()
  end
end
