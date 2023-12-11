defmodule Day8Test do
  use ExUnit.Case
  import AdventOfCode2023.Test.Common

  test "part one example" do
    assert 6 ==
             load_input(8, "example")
             |> Day8.part_one()
  end

  test "part one real" do
    assert 15989 ==
             load_input(8, "real")
             |> Day8.part_one()
  end

  test "part two example" do
    assert 6 ==
             load_input(8, "example")
             |> Day8.part_two()
  end

  test "part two real" do
    assert 13_830_919_117_339 ==
             load_input(8, "real")
             |> Day8.part_two()
  end
end
