defmodule Day3 do
  def read_input(name) do
    File.read!("./input/#{name}")
  end

  def find_muls(corr) do
    Regex.scan(~r/mul\(\d+,\d+\)/, corr)
    |> Enum.map(fn [m] -> m end)
  end

  def do_mul(mul) do
    [[_, a, b]] = Regex.scan(~r/mul\((\d+),(\d+)\)/, mul)
    {x, _} = Integer.parse(a)
    {y, _} = Integer.parse(b)
    x * y
  end

  def sum_muls(name) do
    read_input(name)
    |> find_muls()
    |> Enum.map(&do_mul/1)
    |> Enum.sum()
  end

  def find_dos(corr) do
    find_dont(corr, %{dos: [], donts: []})
  end

  def find_dont("", results), do: results

  def find_dont(corr, results) do
    case Regex.run(~r/(.*?)don't\(\)(.*)/s, corr) do
      [_, dos, donts] ->
        updated = %{dos: results.dos ++ [dos], donts: results.donts}
        find_do(donts, updated)

      nil ->
        %{dos: results.dos ++ [corr], donts: results.donts}
    end
  end

  def find_do("", results), do: results

  def find_do(corr, results) do
    case Regex.run(~r/(.*?)do\(\)(.*)/s, corr) do
      [_, donts, dos] ->
        updated = %{dos: results.dos, donts: results.donts ++ [donts]}
        find_dont(dos, updated)

      nil ->
        %{dos: results.dos, donts: results.donts ++ [corr]}
    end
  end

  def find_enabled_muls(corr) do
    %{dos: dos} = find_dos(corr)

    dos
    |> Enum.map(&find_muls/1)
    |> List.flatten()
    |> Enum.map(&do_mul/1)
    |> Enum.sum()
  end

  def find_part2(name) do
    read_input(name)
    |> find_enabled_muls()
  end
end
