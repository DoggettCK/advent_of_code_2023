defmodule Day6Test do
  use ExUnit.Case
  import AdventOfCode2023.Test.Common

  test "part one example" do
    assert 288 ==
             load_input(6, "example")
             |> Day6.part_one()
  end

  test "part one real" do
    assert 633_080 ==
             load_input(6, "real")
             |> Day6.part_one()
  end

  test "part two example" do
    assert 71503 ==
             load_input(6, "example")
             |> Day6.part_two()
  end

  test "part two real" do
    assert 20_048_741 ==
             load_input(6, "real")
             |> Day6.part_two()
  end
end
