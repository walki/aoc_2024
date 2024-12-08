defmodule Day7Test do
  use ExUnit.Case

  import Day7

  test "read_input" do
    input = read_input("day7test")

    assert 9 == length(input)
    assert %{answer: 190, operands: [10, 19]} == input |> Enum.at(0)
  end

  test "evaluate" do
    assert 190 == evaluate(%{answer: 190, operands: [10, 19]})
    assert 3267 == evaluate(%{answer: 3267, operands: [81, 40, 27]})
    assert 0 == evaluate(%{answer: 83, operands: [17, 5]})
  end

  test "calibration_results" do
    input = read_input("day7test")

    assert 3749 == calibration_results(input)
  end

  test "calibration_results for real" do
    input = read_input("day7input")

    assert 1298300076754 == calibration_results(input)
  end

  # Part 2
  test "evaluate_concat" do
    assert 190 == evaluate_concat(%{answer: 190, operands: [10, 19]})
    assert 3267 == evaluate_concat(%{answer: 3267, operands: [81, 40, 27]})
    assert 156 == evaluate_concat(%{answer: 156, operands: [15, 6]})
    assert 7290 == evaluate_concat(%{answer: 7290, operands: [6, 8, 6, 15]})
    assert 192 == evaluate_concat(%{answer: 192, operands: [17, 8, 14]})
  end

  test "calib part 2" do
    input = read_input("day7test")

    assert 11387 == calibration_results_part2(input)
  end

  test "calib part 2 for real" do
    input = read_input("day7input")

    assert 248427118972289 == calibration_results_part2(input)
  end
end
