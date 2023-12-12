defmodule Day11Test do
  use ExUnit.Case
  import AdventOfCode2023.Test.Common

  test "part one example" do
    assert 374 ==
             load_input(11, "example")
             |> Day11.part_one()
  end

  test "part one real" do
    assert 9_556_712 ==
             load_input(11, "real")
             |> Day11.part_one()
  end

  test "part two example" do
    assert 82_000_210 ==
             load_input(11, "example")
             |> Day11.part_two()
  end

  test "part two real" do
    assert 678_626_199_476 ==
             load_input(11, "real")
             |> Day11.part_two()
  end
end
