defmodule Day10Test do
  use ExUnit.Case
  import AdventOfCode2023.Test.Common

  test "part one example" do
    assert 8 ==
             load_input(10, "example")
             |> Day10.part_one()
  end

  test "part one real" do
    assert 6738 ==
             load_input(10, "real")
             |> Day10.part_one()
  end

  test "part two example" do
    assert 1 ==
             load_input(10, "example")
             |> Day10.part_two()
  end

  test "part two real" do
    assert 579 ==
             load_input(10, "real")
             |> Day10.part_two()
  end
end
