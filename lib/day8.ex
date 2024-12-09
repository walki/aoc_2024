defmodule Day8 do
  def read_input(name) do
    map =
      File.read!("./input/#{name}")
      |> String.split("\r\n", trim: true)

    %{map: map}
  end

  def setup_match(map) do
    joined = Enum.join(map) |> String.split("", trim: true)
    row_length = map |> Enum.at(0) |> String.length()
    {joined, row_length}
  end

  def find_antennas(state) do
    {joined, row_length} = setup_match(state.map)

    antennas = find_ant(row_length, 0, joined, %{})

    Map.put(state, :antennas, antennas)
  end

  def find_ant(_, _, [], results), do: results

  def find_ant(row_len, count, ["." | rest] = _locs, results) do
    find_ant(row_len, count + 1, rest, results)
  end

  def find_ant(row_len, count, [ant_freq | rest] = _locs, results) do
    ant_row = Integer.floor_div(count, row_len)
    ant_col = Integer.mod(count, row_len)

    antennas = Map.get(results, ant_freq, [])

    find_ant(
      row_len,
      count + 1,
      rest,
      Map.put(results, ant_freq, [%{r: ant_row, c: ant_col} | antennas])
    )
  end

  def find_antinodes(loc1, loc2, row_len, col_len) do
    dx = loc1.c - loc2.c
    dy = loc1.r - loc2.r

    an1_r = loc1.r + dy
    an1_c = loc1.c + dx
    an2_r = loc1.r - 2 * dy
    an2_c = loc1.c - 2 * dx

    nodes = maybe_add_node(%{r: an1_r, c: an1_c}, row_len, col_len, [])
    maybe_add_node(%{r: an2_r, c: an2_c}, row_len, col_len, nodes)
  end

  def maybe_add_node(%{r: row, c: col} = node, row_len, col_len, nodes) do
    case within_bounds?(row, col, row_len, col_len) do
      true -> [node | nodes]
      _ -> nodes
    end
  end

  def find_antinodes_for_antenna(state) do
    Map.keys(state.antennas)
    |> Enum.reduce([], fn key, antinodes ->
      ans =
        state.antennas
        |> Map.get(key)
        |> find_all_antinodes(state)

      [ans | antinodes]
    end)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.count()
  end

  def find_all_antinodes(all, state) do
    result = find_all_antinodes(state, all, [])
    List.flatten(result)
  end

  def find_all_antinodes(_state, [_curr], antinodes), do: antinodes

  def find_all_antinodes(state, [curr | rest], antinodes) do
    curr_ans = do_find_curr_antinodes(state, curr, rest, antinodes)
    find_all_antinodes(state, rest, [curr_ans | antinodes])
  end

  def do_find_curr_antinodes(_state, _curr, [], antinodes), do: antinodes

  def do_find_curr_antinodes(state, curr, [next | rest], antinodes) do
    row_len = row_length(state)
    col_len = col_length(state)
    curr_ans = find_antinodes(curr, next, row_len, col_len)
    do_find_curr_antinodes(state, curr, rest, [curr_ans | antinodes])
  end

  def on_map?(%{r: row, c: col}, map) do
    row_length = map |> Enum.at(0) |> String.length()
    col_length = length(map)
    within_bounds?(row, col, row_length, col_length)
  end

  def within_bounds?(row, col, row_len, col_len)
      when row >= 0 and row < row_len and
             col >= 0 and col < col_len,
      do: true

  def within_bounds?(_, _, _, _), do: false

  def row_length(state) do
    state.map |> Enum.at(0) |> String.length()
  end

  def col_length(state) do
    length(state.map)
  end
end
