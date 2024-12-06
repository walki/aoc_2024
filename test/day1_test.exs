defmodule Day1Test do
  use ExUnit.Case

  @tag :pending
  test "read_input" do
    assert Day1.read_input("day1test") == {[3, 4, 2, 1, 3, 3], [4, 3, 5, 3, 9, 3]}
  end

  @tag :pending
  test "find_distance" do
    a = [3, 4, 2, 1, 3, 3]
    b = [4, 3, 5, 3, 9, 3]
    assert Day1.find_distance({a, b}) == 11
  end

  @tag :pending
  test "find_day1_part1" do
    distance =
      Day1.read_input("day1input")
      |> Day1.find_distance()

    assert distance == 1506483
  end

  @tag :pending
  test "find_similarity_score" do
    a = [3, 4, 2, 1, 3, 3]
    b = [4, 3, 5, 3, 9, 3]
    assert Day1.find_similarity_score({a, b}) == 31
  end

  @tag :pending
  test "find_day1_part2" do
    similarity =
      Day1.read_input("day1input")
      |> Day1.find_similarity_score()

    assert similarity == 23126924
  end
end
