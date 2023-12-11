defmodule Day9Test do
  use ExUnit.Case
  import AdventOfCode2023.Test.Common

  test "part one example" do
    assert 114 ==
             load_input(9, "example")
             |> Day9.part_one()
  end

  test "part one real" do
    assert 2_038_472_161 ==
             load_input(9, "real")
             |> Day9.part_one()
  end

  test "part two example" do
    assert 2 ==
             load_input(9, "example")
             |> Day9.part_two()
  end

  test "part two real" do
    assert 1091 ==
             load_input(9, "real")
             |> Day9.part_two()
  end
end
