defmodule Day4 do
  def read_input(name) do
    File.read!("./input/#{name}")
  end

  def solve_part1(name) do
    read_input(name)
    |> find_xmas()
  end

  def find_xmas(input) do
    horiz = find_horizontal_xmas(input)
    vert = find_vertical_xmas(input)
    left = find_left_diag(input)
    right = find_right_diag(input)

    [horiz, vert, left, right]
    |> Enum.map(&find_count/1)
    |> Enum.sum()
  end

  def find_count(rows) do
    rows
    |> Enum.map(fn line -> find_forward(line, 0) + find_backward(line, 0) end)
    |> Enum.sum()
  end

  def find_horizontal_xmas(input) do
    input
    |> String.split("\r\n", trim: true)
  end

  def find_vertical_xmas(input) do
    all =
      input
      |> String.split("\r\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

    transpose(all)
    |> Enum.join("\r\n")
    |> find_horizontal_xmas()
  end

  def transpose(matrix) do
    List.zip(matrix) |> Enum.map(&Tuple.to_list/1)
  end

  def find_forward(line, count) do
    case Regex.run(~r/(.*?)(XMAS)(.*)/, line) do
      [_, _, _, rest] -> find_forward(rest, count + 1)
      nil -> count
    end
  end

  def find_backward(line, count) do
    case Regex.run(~r/(.*?)(SAMX)(.*)/, line) do
      [_, _, _, rest] -> find_backward(rest, count + 1)
      nil -> count
    end
  end

  def find_left_diag(input) do
    matrix =
      input
      |> String.split("\r\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

    diagonals(matrix)
    |> Enum.map(&Enum.join/1)
  end

  defp diagonals(matrix) do
    size = length(matrix)

    for d <- 0..(2 * size - 2) do
      for i <- 0..d, j = d - i, i < size, j < size, do: Enum.at(Enum.at(matrix, i), j)
    end
  end

  def find_right_diag(input) do
    matrix =
      input
      |> String.split("\r\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

    opposite_diagonals(matrix)
    |> Enum.map(&Enum.join/1)
  end

  defp opposite_diagonals(matrix) do
    size = length(matrix)

    for d <- 0..(2 * size - 2) do
      for i <- 0..d, j = d - i, i < size, j < size, do: Enum.at(Enum.at(matrix, i), size - 1 - j)
    end
  end

  # Part 2

  def solve_part2(name) do
    read_input(name)
    |> count_part2_pattern()
  end

  def count_part2_pattern(input) do
    matrix = get_matrix(input)

    matrix_check(matrix, matrix, 0)
  end

  def get_matrix(input) do
    input
    |> String.split("\r\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def matrix_check([[_, _], [_, _], [_, _] | _], full_lines, count) do
    [_ | rest_of_Lines] = full_lines
    matrix_check(rest_of_Lines, rest_of_Lines, count)
  end

  def matrix_check([_, _], _, count), do: count

  def matrix_check(
        [["M", _, "S" | _] = first, [_, "A", _ | _] = second, ["M", _, "S" | _] = third | rest],
        full_lines,
        count
      ) do
    shift_left(first, second, third, rest, full_lines, count + 1)
  end

  def matrix_check(
        [["M", _, "M" | _] = first, [_, "A", _ | _] = second, ["S", _, "S" | _] = third | rest],
        full_lines,
        count
      ) do
    shift_left(first, second, third, rest, full_lines, count + 1)
  end

  def matrix_check(
        [["S", _, "M" | _] = first, [_, "A", _ | _] = second, ["S", _, "M" | _] = third | rest],
        full_lines,
        count
      ) do
    shift_left(first, second, third, rest, full_lines, count + 1)
  end

  def matrix_check(
        [["S", _, "S" | _] = first, [_, "A", _ | _] = second, ["M", _, "M" | _] = third | rest],
        full_lines,
        count
      ) do
    shift_left(first, second, third, rest, full_lines, count + 1)
  end

  def matrix_check(
        [[_, _, _ | _] = first, [_, _, _ | _] = second, [_, _, _ | _] = third | rest],
        full_lines,
        count
      ) do
    shift_left(first, second, third, rest, full_lines, count)
  end

  def shift_left(first, second, third, rest, full_lines, count) do
    [_ | rest_first] = first
    [_ | rest_second] = second
    [_ | rest_third] = third
    updated = [rest_first, rest_second, rest_third, rest]
    matrix_check(updated, full_lines, count)
  end
end
