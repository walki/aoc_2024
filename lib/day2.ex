defmodule Day2 do
  def read_input(name) do
    File.read!("./input/#{name}")
    |> String.split("\r\n", trim: true)
    |> Enum.map(fn report ->
      String.split(report, " ", trim: true)
      |> Enum.map(fn l ->
        {level, _} = Integer.parse(l)
        level
      end)
    end)
  end

  def get_safe_reports(name) do
    read_input(name)
    |> Enum.count(&safe?/1)
  end

  def get_dampened_safe_reports(name) do
    read_input(name)
    |> Enum.count(&prob_dampener/1)
  end

  def safe?(levels) do
    asc_or_desc?(levels) && do_check_bounds(levels)
  end

  def asc_or_desc?(levels) do
    sorted = Enum.sort(levels)
    reversed = Enum.reverse(sorted)

    sorted == levels || reversed == levels
  end

  def do_check_bounds([_]), do: true

  def do_check_bounds([a, b | rest]) do
    case with_in_bounds?(a, b) do
      true -> do_check_bounds([b | rest])
      false -> false
    end
  end

  def with_in_bounds?(a, b) when a >= b + 1 and a <= b + 3, do: true
  def with_in_bounds?(b, a) when a >= b + 1 and a <= b + 3, do: true
  def with_in_bounds?(_, _), do: false

  def prob_dampener(levels) do
    case safe?(levels) do
      true -> true
      false -> do_dampening([], levels)
    end
  end

  def do_dampening(start, []), do: safe?(start)

  def do_dampening(start, [h | rest]) do
    case safe?(start ++ rest) do
      true -> true
      false -> do_dampening(start ++ [h], rest)
    end
  end
end
