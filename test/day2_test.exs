defmodule Day2Test do
  use ExUnit.Case
  import AdventOfCode2023.Test.Common

  test "part one example" do
    assert 8 ==
             load_input(2, "example")
             |> Day2.part_one()
  end

  test "part one real" do
    assert 2683 ==
             load_input(2, "real")
             |> Day2.part_one()
  end

  test "part two example" do
    assert 2286 ==
             load_input(2, "example")
             |> Day2.part_two()
  end

  test "part two real" do
    assert 49710 ==
             load_input(2, "real")
             |> Day2.part_two()
  end
end
