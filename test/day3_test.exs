defmodule Day3Test do
  use ExUnit.Case
  import AdventOfCode2023.Test.Common

  test "part one example" do
    assert 4361 ==
             load_input(3, "example")
             |> Day3.part_one()
  end

  test "part one real" do
    assert 514_969 ==
             load_input(3, "real")
             |> Day3.part_one()
  end

  test "part two example" do
    assert 467_835 ==
             load_input(3, "example")
             |> Day3.part_two()
  end

  test "part two real" do
    assert 78_915_902 ==
             load_input(3, "real")
             |> Day3.part_two()
  end
end
