defmodule Day10 do
  def read_input(name) do
    input =
      File.read!("./input/#{name}")

    get_map(input)
  end

  def get_map(input) do
    lines = input |> String.split("\r\n", trim: true)
    col_len = Enum.count(lines)
    row_len = List.first(lines) |> String.length()

    rows = lines |> Enum.map(&String.split(&1, "", trim: true))
    map = 0..100_000 |> Enum.zip(rows)
    %{row_len: row_len, col_len: col_len, map: map}
  end

  def find_trailheads(state) do
    heads =
      state.map
      |> Enum.reduce([], fn row_with_idx, trailheads ->
        {row_idx, row} = row_with_idx

        row_heads =
          find_row_heads(row, 0, []) |> Enum.map(fn col_idx -> {row_idx, col_idx} end)

        [row_heads | trailheads]
      end)
      |> List.flatten()

    Map.merge(state, %{heads: heads})
  end

  def find_row_heads([], _, idxs), do: idxs

  def find_row_heads(["0" | rest], curr, idxs) do
    find_row_heads(rest, curr + 1, [curr | idxs])
  end

  def find_row_heads([_ | rest], curr, idxs) do
    find_row_heads(rest, curr + 1, idxs)
  end

  def find_eligible_neighbors(9, {row, col}, _state), do: {:done, {row, col}}

  def find_eligible_neighbors(val, {row, col}, state) do
    top = check(val + 1, {row - 1, col}, state)
    bottom = check(val + 1, {row + 1, col}, state)
    left = check(val + 1, {row, col - 1}, state)
    right = check(val + 1, {row, col + 1}, state)

    result = [top, bottom, left, right] |> Enum.filter(fn x -> x != nil end)
    {:ok, result}
  end

  @spec check(any(), {any(), any()}, any()) :: nil | {any(), integer()}
  def check(val, {row_idx, col_idx}, state) do
    case within_bounds?(row_idx, col_idx, state.row_len, state.col_len) do
      true ->
        {_, row} = state.map |> Enum.at(row_idx)
        v = row |> Enum.at(col_idx)

        case String.to_integer(v) == val do
          true -> {row_idx, col_idx}
          false -> nil
        end

      false ->
        nil
    end
  end

  def within_bounds?(row, col, row_len, col_len)
      when row >= 0 and row < row_len and
             col >= 0 and col < col_len,
      do: true

  def within_bounds?(_, _, _, _), do: false

  def find_paths(state) do
    state.heads |> Enum.map(&do_find_paths(1, &1, state))
  end

  def do_find_paths(val, loc, state) do
    {status, result} = find_eligible_neighbors(val, loc, state)

    case status == :done do
      false -> result |> Enum.map(fn r -> do_find_paths(val + 1, r, state) end)
      true -> result
    end
  end
end
