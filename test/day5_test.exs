defmodule Day5Test do
  use ExUnit.Case
  import AdventOfCode2023.Test.Common

  test "part one example" do
    assert 35 ==
             load_input(5, "example")
             |> Day5.part_one()
  end

  test "part one real" do
    assert 240_320_250 ==
             load_input(5, "real")
             |> Day5.part_one()
  end

  test "part two example" do
    assert nil ==
             load_input(5, "example")
             |> Day5.part_two()
  end

  test "part two real" do
    assert nil ==
             load_input(5, "real")
             |> Day5.part_two()
  end
end
