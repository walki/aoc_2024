defmodule Day6 do
  def read_input(name) do
    map =
      File.read!("./input/#{name}")
      |> String.split("\r\n", trim: true)

    %{map: map}
  end

  def find_starting_positions(%{map: map} = state) do
    player = find_player(map)
    obstructions = find_all_obstructions(map)
    on_map = true
    in_cycle = false
    visited = MapSet.new() |> MapSet.put(player.loc)
    visited_with_dir = MapSet.new() |> MapSet.put(%{loc: player.loc, dir: player.dir})

    Map.merge(state, %{
      player: player,
      obstructions: obstructions,
      on_map: on_map,
      in_cycle: in_cycle,
      visited: visited,
      visited_with_dir: visited_with_dir
    })
  end

  def find_player(map) do
    {joined, row_length} = setup_match(map)

    find_plyr(row_length, 0, joined)
  end

  def find_plyr(_, _, []), do: %{}

  def find_plyr(row_len, count, [loc | _rest] = _locs)
      when loc == "^" or loc == "<" or loc == ">" or loc == "v" do
    plyr_row = Integer.floor_div(count, row_len)
    plyr_col = Integer.mod(count, row_len)
    %{loc: %{row: plyr_row, col: plyr_col}, dir: loc}
  end

  def find_plyr(row_len, count, [_ | rest] = _locs) do
    find_plyr(row_len, count + 1, rest)
  end

  def setup_match(map) do
    joined = Enum.join(map) |> String.split("", trim: true)
    row_length = map |> Enum.at(0) |> String.length()
    {joined, row_length}
  end

  def find_all_obstructions(map) do
    {joined, row_length} = setup_match(map)

    find_obs(row_length, 0, joined, [])
  end

  def find_obs(_, _, [], results), do: results

  def find_obs(row_len, count, ["#" | rest] = _locs, results) do
    obst_row = Integer.floor_div(count, row_len)
    obst_col = Integer.mod(count, row_len)
    find_obs(row_len, count + 1, rest, [%{row: obst_row, col: obst_col} | results])
  end

  def find_obs(row_len, count, [_ | rest] = _locs, results) do
    find_obs(row_len, count + 1, rest, results)
  end

  def obstruction_in_front?(player, obstructions) do
    next = loc_in_front(player)
    Enum.any?(obstructions, fn x -> x.row == next.row && x.col == next.col end)
  end

  def loc_in_front(%{loc: %{row: row, col: col}, dir: dir} = _player) do
    case dir do
      "^" -> %{row: row - 1, col: col}
      "<" -> %{row: row, col: col - 1}
      ">" -> %{row: row, col: col + 1}
      "v" -> %{row: row + 1, col: col}
    end
  end

  def next_move(state) do
    player =
      case obstruction_in_front?(state.player, state.obstructions) do
        false ->
          loc = loc_in_front(state.player)
          %{loc: loc, dir: state.player.dir}

        true ->
          dir = turn_right(state.player.dir)
          %{loc: state.player.loc, dir: dir}
      end

    %{state | player: player}
  end

  def find_cycles(start, file_name, min) do
    # poss = poss_locations(start)

    ending = Day6.run_guard(start, file_name, min)
    poss = ending.visited

    poss
    |> Enum.reduce([], fn p, cycle_locs ->
      added = add_obs(start, p)
      ending = run_guard(added, file_name, min)
      case ending.in_cycle do
        true -> [p | cycle_locs]
        false -> cycle_locs
      end
    end)
  end

  def add_obs(state, loc) do
    %{state | obstructions: [loc | state.obstructions]}
  end

  def poss_locations(state) do
    rl = row_length(state)
    cl = col_length(state)

    0..(rl - 1)
    |> Enum.to_list()
    |> Enum.reduce([], fn row, acc ->
      0..(cl - 1)
      |> Enum.to_list()
      |> Enum.reduce(acc, fn col, acc ->
        loc = %{row: row, col: col}

        case occupado?(state, loc) do
          false -> [loc | acc]
          true -> acc
        end
      end)
    end)
  end

  def occupado?(state, loc) do
    state.player.loc == loc ||
      Enum.any?(state.obstructions, fn x -> x.row == loc.row && x.col == loc.col end)
  end

  def row_length(state) do
    state.map |> Enum.at(0) |> String.length()
  end

  def col_length(state) do
    length(state.map)
  end

  def run_guard(state, file_name, min) do
    moved = next_move(state)

    print_state_file(moved, file_name, min)

    case in_cycle?(moved) do
      true ->
        %{moved | in_cycle: true}

      false ->
        case on_map?(moved.player.loc, moved.map) do
          false ->
            %{moved | on_map: false}

          true ->
            added_location = %{
              moved
              | visited: MapSet.put(moved.visited, moved.player.loc),
                visited_with_dir:
                  MapSet.put(moved.visited_with_dir, %{
                    loc: moved.player.loc,
                    dir: moved.player.dir
                  })
            }

            run_guard(added_location, file_name, min)
        end
    end
  end

  def in_cycle?(moved) do
    curr = moved.player

    moved.visited_with_dir
    |> MapSet.to_list()
    |> Enum.any?(fn v ->
      v.loc.col == curr.loc.col && v.loc.row == curr.loc.row && v.dir == curr.dir
    end)
  end

  def turn_right("^"), do: ">"
  def turn_right(">"), do: "v"
  def turn_right("v"), do: "<"
  def turn_right("<"), do: "^"

  def on_map?(%{row: row, col: col}, map) do
    row_length = map |> Enum.at(0) |> String.length()
    col_length = length(map)
    within_bounds?(row, col, row_length, col_length)
  end

  def within_bounds?(row, col, row_len, col_len)
      when row >= 0 and row < row_len and
             col >= 0 and col < col_len,
      do: true

  def within_bounds?(_, _, _, _), do: false

  def print_state_file(state, file_name, min) do
    vis_len = length(MapSet.to_list(state.visited))

    if vis_len >= min do
      row_length = state.map |> Enum.at(0) |> String.length()
      col_length = length(state.map)

      {:ok, file} = File.open("./output/#{file_name}", [:append])

      IO.puts(file, "----State for #{col_length}x#{row_length} - #{vis_len} ----------------")
      IO.puts(file, "Player: ")
      IO.inspect(file, state.player, [])
      IO.puts(file, "------------------------------------")

      print_out = get_print_map_quick(state, row_length, col_length)

      IO.puts(file, print_out)
      IO.puts(file, "------------------------------------")
      IO.puts(file, "")

      File.close(file)
    end
  end

  def print_state(state) do
    row_length = state.map |> Enum.at(0) |> String.length()
    col_length = length(state.map)
    IO.puts("----State for #{col_length}x#{row_length} ------------------")
    IO.puts("Player: ")
    IO.inspect(state.player)
    IO.puts("------------------------------------")

    print_out = get_print_map(state, row_length, col_length)

    IO.puts(print_out)
    IO.puts("------------------------------------")
    IO.puts("")
  end

  def get_print_map(state, row_length, col_length) do
    Enum.to_list(0..(row_length - 1))
    |> Enum.reduce("", fn row, output ->
      print_row =
        Enum.to_list(0..(col_length - 1))
        |> Enum.reduce("", fn col, print_row ->
          obstr_loc = Enum.any?(state.obstructions, fn o -> o.col == col && o.row == row end)
          plyr_loc = state.player.loc.col == col && state.player.loc.row == row

          visited_loc =
            MapSet.to_list(state.visited) |> Enum.any?(fn v -> v.col == col && v.row == row end)

          print_row <> print_char(visited_loc, plyr_loc, obstr_loc, state.player.dir)
        end)

      output <> print_row <> "\r\n"
    end)
  end

  def get_print_map_quick(state, row_len, col_len) do
    bg = print_bg(row_len, col_len)

    obs =
      state.obstructions
      |> Enum.reduce(bg, fn o, os ->
        replace(os, o.row, o.col, row_len, "#")
      end)

    visited =
      state.visited
      |> MapSet.to_list()
      |> Enum.reduce(obs, fn v, vs ->
        replace(vs, v.row, v.col, row_len, "X")
      end)

    plyr = replace(visited, state.player.loc.row, state.player.loc.col, row_len, state.player.dir)

    plyr
    |> String.split("", trim: true)
    |> Enum.chunk_every(row_len)
    |> Enum.join("\r\n")
  end

  def replace(str, r, c, rl, ch) do
    idx = r * rl + c
    before_i = String.slice(str, 0, idx)
    after_i = String.slice(str, idx + 1, String.length(str))
    before_i <> ch <> after_i
  end

  def print_bg(r, c) do
    String.duplicate(".", r * c)
  end

  def print_char(_visited, true = _player, false = _obstructed, player_dir), do: player_dir
  def print_char(true = _visited, _player, false = _obstructed, _), do: "X"
  def print_char(false = _visited, false = _player, true = _obstructed, _), do: "#"
  def print_char(true, _, true, _), do: "?"
  def print_char(_, true, true, _), do: "?"
  def print_char(_, _, _, _), do: "."
end
