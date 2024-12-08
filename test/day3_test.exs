defmodule Day3Test do
  use ExUnit.Case

  @tag :pending
  test "read_input" do
    corrupted = Day3.read_input("day3test")
    assert corrupted == "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
  end

  @tag :pending
  test "find_muls" do
    corrupted = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
    [a, b, c, d] = Day3.find_muls(corrupted)
    assert a == "mul(2,4)"
    assert b == "mul(5,5)"
    assert c == "mul(11,8)"
    assert d == "mul(8,5)"
  end

  @tag :pending
  test "do_mul" do
    assert 8 == Day3.do_mul("mul(2,4)")
    assert 25 == Day3.do_mul("mul(5,5)")
    assert 88 == Day3.do_mul("mul(11,8)")
    assert 40 == Day3.do_mul("mul(8,5)")
    assert 10_000 == Day3.do_mul("mul(100,100)")
  end

  @tag :pending
  test "sum_muls test" do
    assert 161 == Day3.sum_muls("day3test")
  end

  @tag :pending
  test "sum_muls part 1" do
    assert 187_825_547 == Day3.sum_muls("day3input")
  end

  @tag :pending
  test "find_dos_and_don'ts" do
    corrupted = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

    assert %{
             dos: ["xmul(2,4)&mul[3,7]!^", "?mul(8,5))"],
             donts: ["_mul(5,5)+mul(32,64](mul(11,8)un"]
           } == Day3.find_dos(corrupted)

    assert %{dos: [""], donts: ["abcd"]} == Day3.find_dos("don't()abcd")
    assert %{dos: ["abcd"], donts: []} == Day3.find_dos("abcd")

    assert %{dos: ["a", "", "b"], donts: ["x", "y", "z"]} ==
             Day3.find_dos("adon't()xdo()don't()ydo()bdon't()z")
  end

  @tag :pending
  test "find_enabled_muls" do
    corrupted = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

    assert 48 == Day3.find_enabled_muls(corrupted)
  end

  @tag :pending
  test "test find_part2" do
    assert 48 == Day3.find_part2("day3testpart2")
    assert 85_508_223 = Day3.find_part2("day3input")
  end
end
