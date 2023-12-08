defmodule Day1Test do
  use ExUnit.Case
  import AdventOfCode2023.Test.Common

  test "part one example" do
    assert 198 ==
             load_input(1, "example")
             |> Day1.part_one()
  end

  test "part one real" do
    assert 55538 ==
             load_input(1, "real")
             |> Day1.part_one()
  end

  test "part two example" do
    assert 281 ==
             load_input(1, "example")
             |> Day1.part_two()
  end

  test "part two real" do
    assert 54875 ==
             load_input(1, "real")
             |> Day1.part_two()
  end
end
