defmodule Day7 do

  def read_input(name) do
    File.read!("./input/#{name}")
    |> String.split("\r\n", trim: true)
    |> Enum.map(fn eq ->
      [first, second] = eq |> String.split(": ", trim: true)
      answer = String.to_integer(first)
      operands = second |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
      %{answer: answer, operands: operands}
    end)
  end

  def calibration_results(input) do
    input
    |> Enum.map(&evaluate/1)
    |> Enum.sum()
  end

  def calibration_results_part2(input) do
    input
    |> Enum.map(&evaluate_concat/1)
    |> Enum.sum()

  end

  def evaluate(%{answer: answer, operands: [first | rest]}) do
    result = do_evaluate(answer, first, rest)

    case result do
      :ok -> answer
      _ -> 0
    end
  end

  def do_evaluate(answer, answer, []), do: :ok
  def do_evaluate(_answer, _curr, []), do: :no_match

  def do_evaluate(answer, curr, [next | rest]) do
    status1 = do_evaluate(answer, curr * next, rest)
    status2 = do_evaluate(answer, curr + next, rest)
    check_result(status1, status2)
  end

  def evaluate_concat(%{answer: answer, operands: [first | rest]}) do
    result = do_evaluate_concat(answer, first, rest)

    case result do
      :ok -> answer
      _ -> 0
    end
  end

  def do_evaluate_concat(answer, answer, []), do: :ok
  def do_evaluate_concat(_answer, _curr, []), do: :no_match

  def do_evaluate_concat(answer, curr, [next | rest]) do
    status1 = do_evaluate_concat(answer, curr * next, rest)
    status2 = do_evaluate_concat(answer, curr + next, rest)
    concat = "#{curr}#{next}" |> String.to_integer()
    status3 = do_evaluate_concat(answer, concat, rest)
    check_result(status1, status2, status3)
  end

  def check_result(st1, st2, st3 \\ :no_match)
  def check_result(:ok, _, _), do: :ok
  def check_result(_, :ok, _), do: :ok
  def check_result(_, _, :ok), do: :ok
  def check_result(_, _, _), do: :no_match
end
