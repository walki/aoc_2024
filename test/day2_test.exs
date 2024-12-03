defmodule Day2Test do
  use ExUnit.Case

  test "read_input" do
    [a, b | _] = reports = Day2.read_input("day2test")
    assert a == [7,6,4,2,1]
    assert b == [1,2,7,8,9]
    assert length(reports) == 6
  end

  test "get_safe_reports_testfile" do
    assert Day2.get_safe_reports("day2test") == 2
  end

  test "get_safe_reports_part1" do
    assert Day2.get_safe_reports("day2input") == 287
  end

  test "safe?" do
    assert Day2.safe?([7,6,4,2,1]) == true
    assert Day2.safe?([1,2,7,8,9]) == false
    assert Day2.safe?([9,7,6,2,1]) == false
    assert Day2.safe?([1,3,2,4,5]) == false
    assert Day2.safe?([8,6,4,4,1]) == false
    assert Day2.safe?([1,3,6,7,9]) == true
    assert Day2.safe?([1,3,6,7,11]) == false
  end

  test "asc_or_desc?" do
    assert Day2.asc_or_desc?([7,6,4,2,1]) == true
    assert Day2.asc_or_desc?([1,2,7,8,9]) == true
    assert Day2.asc_or_desc?([1,3,2,4,5]) == false
  end

  test "prob_dampener" do
    assert Day2.prob_dampener([7,6,4,2,1]) == true
    assert Day2.prob_dampener([1,2,7,8,9]) == false
    assert Day2.prob_dampener([9,7,6,2,1]) == false
    assert Day2.prob_dampener([1,3,2,4,5]) == true
    assert Day2.prob_dampener([8,6,4,4,1]) == true
    assert Day2.prob_dampener([1,3,6,7,9]) == true
    assert Day2.prob_dampener([1,3,6,7,11]) == true
    assert Day2.prob_dampener([1,3,6,7,5,6]) == false
  end

  test "testdata safe dampened" do
    assert Day2.get_dampened_safe_reports("day2test") == 4
  end

  test "part2  safe dampened" do
    assert Day2.get_dampened_safe_reports("day2input") == 354
  end
end
