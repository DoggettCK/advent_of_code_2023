defmodule Day4Test do
  use ExUnit.Case
  import AdventOfCode2023.Test.Common

  test "part one example" do
    assert 13 ==
             load_input(4, "example")
             |> Day4.part_one()
  end

  test "part one real" do
    assert 22193 ==
             load_input(4, "real")
             |> Day4.part_one()
  end

  test "part two example" do
    assert 30 ==
             load_input(4, "example")
             |> Day4.part_two()
  end

  test "part two real" do
    assert 5_625_994 ==
             load_input(4, "real")
             |> Day4.part_two()
  end
end
