defmodule Day4Test do
  use ExUnit.Case

  @tag :pending
  test "find xmas" do
    input =
      """
      MMMSXXMASM
      MSAMXMSMSA
      AMXSXMAAMM
      MSAMASMSMX
      XMASAMXAMM
      XXAMMXXAMA
      SMSMSASXSS
      SAXAMASAAA
      MAMMMXMMMM
      MXMXAXMASX
      """

    assert Day4.find_xmas(input) == 18
  end

  @tag :pending
  test "find_forward" do
    assert 1 == Day4.find_forward("XMAS", 0)
    assert 2 == Day4.find_forward("XMASXMAS", 0)
    assert 3 == Day4.find_forward("SSSXMASXXMASAAXMASAAA", 0)
  end

  @tag :pending
  test "find_backward" do
    assert 1 == Day4.find_backward("SAMXS", 0)
    assert 1 == Day4.find_backward("SAMX", 0)
    assert 2 == Day4.find_backward("SAMXSAMX", 0)
    assert 3 == Day4.find_backward("SSSAMXXSAMXAASAMXAAA", 0)
  end

  @tag :pending
  test "find_vertical" do
    input =
      """
      MMMSXXMASM
      MSAMXMSMSA
      AMXSXMAAMM
      MSAMASMSMX
      XMASAMXAMM
      XXAMMXXAMA
      SMSMSASXSS
      SAXAMASAAA
      MAMMMXMMMM
      MXMXAXMASX
      """

    assert [
             "MMAMXXSSMM",
             "MSMSMXMAAX",
             "MAXAAASXMM",
             "SMSMSMMAMX",
             "XXXAAMSMMA",
             "XMMSMXAAXX",
             "MSAMXXSSMM",
             "AMASAAXAMA",
             "SSMMMMSAMS",
             "MAMXMASAMX"
           ] == Day4.find_vertical_xmas(input)
  end

  @tag :pending
  test "transpose" do
    matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    transposed = Day4.transpose(matrix)
    assert transposed == [[1, 4, 7], [2, 5, 8], [3, 6, 9]]
  end

  @tag :pending
  test "find_left_diag" do
    input = """
    abcd
    efgh
    ijkl
    mnop
    """

    assert [
             "a",
             "be",
             "cfi",
             "dgjm",
             "hkn",
             "lo",
             "p"
           ] == Day4.find_left_diag(input)
  end

  @tag :pending
  test "find_right_diag" do
    input = """
    abcd
    efgh
    ijkl
    mnop
    """

    expected_output = [
      "d",
      "ch",
      "bgl",
      "afkp",
      "ejo",
      "in",
      "m"
    ]

    assert Day4.find_right_diag(input) == expected_output
  end

  @tag :pending
  test "solve part 1" do
    assert 18 == Day4.solve_part1("day4test")
    assert 2536 == Day4.solve_part1("day4input")
  end

  @tag :pending
  test "get_matrix" do
    input = """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    """

    assert 9 == Day4.count_part2_pattern(input)
  end

  @tag :pending
  test "solver part 2" do
    assert 9 == Day4.solve_part2("day4test")
    assert 1875 == Day4.solve_part2("day4input")
  end
end
