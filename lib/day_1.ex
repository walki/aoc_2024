defmodule Day1 do
  def read_input(name) do
    File.read!("./input/#{name}")
    |> String.split("\r\n", trim: true)
    |> Enum.map(fn x -> String.split(x, " ", trim: true) end)
    |> Enum.map(fn [x, y] ->
      {a, _} = Integer.parse(x)
      {b, _} = Integer.parse(y)
      {a, b}
    end)
    |> Enum.unzip()
  end

  def find_distance({a, b}) do
    Enum.zip(
      Enum.sort(a),
      Enum.sort(b)
    )
    |> Enum.map(fn {x, y} -> abs(x - y) end)
    |> Enum.sum()
  end

  def find_similarity_score({left, right}) do
    counts = find_right_counts(right)

    left
    |> Enum.map(fn l -> l * Map.get(counts, l, 0) end)
    |> Enum.sum()
  end

  def find_right_counts(right) do
    right
    |> Enum.reduce(%{}, fn r, acc -> Map.update(acc, r, 1, fn x -> x + 1 end) end)
  end
end
