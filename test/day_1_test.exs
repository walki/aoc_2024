defmodule Day1Test do
  use ExUnit.Case

  test "read_input/1" do
    assert Day1.read_input("day1test") == {[3, 4, 2, 1, 3, 3], [4, 3, 5, 3, 9, 3]}
  end

  test "find_distance/2" do
    a = [3, 4, 2, 1, 3, 3]
    b = [4, 3, 5, 3, 9, 3]
    assert Day1.find_distance({a, b}) == 11
  end

  test "find_day_1" do
    distance =
      Day1.read_input("day1input")
      |> Day1.find_distance()

    assert distance == 1506483
  end
end
