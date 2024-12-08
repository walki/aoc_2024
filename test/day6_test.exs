defmodule Day6Test do
  use ExUnit.Case

  @tag :pending
  test "read_input" do
    input = Day6.read_input("day6test")
    assert 10 == length(input.map)
  end

  @tag :pending
  test "find_starting_position" do
    input = Day6.read_input("day6test")

    %{player: %{loc: %{row: row, col: col}, dir: dir}, obstructions: obst} =
      Day6.find_starting_positions(input)

    assert 6 == row
    assert 4 == col
    assert "^" == dir

    assert 8 == length(obst)
  end

  @tag :pending
  test "find_all_obstructions" do
    input = Day6.read_input("day6test")

    obsts = Day6.find_all_obstructions(input.map)
    assert 8 == length(obsts)
    assert Enum.any?(obsts, fn x -> %{row: 0, col: 4} end)
    assert Enum.any?(obsts, fn x -> %{row: 6, col: 1} end)
  end

  @tag :pending
  test "obstruction_in_front" do
    obstructions = [
      %{row: 9, col: 6},
      %{row: 8, col: 0},
      %{row: 7, col: 8},
      %{row: 6, col: 1},
      %{row: 4, col: 7},
      %{row: 3, col: 2},
      %{row: 1, col: 9},
      %{row: 0, col: 4}
    ]

    assert Day6.obstruction_in_front?(%{loc: %{row: 4, col: 2}, dir: "^"}, obstructions)
    assert Day6.obstruction_in_front?(%{loc: %{row: 3, col: 3}, dir: "<"}, obstructions)
    assert Day6.obstruction_in_front?(%{loc: %{row: 3, col: 1}, dir: ">"}, obstructions)
    assert Day6.obstruction_in_front?(%{loc: %{row: 2, col: 2}, dir: "v"}, obstructions)
    refute Day6.obstruction_in_front?(%{loc: %{row: 1, col: 0}, dir: "^"}, obstructions)
  end

  @tag :pending
  test "next_move" do
    obstructions = [
      %{row: 9, col: 6},
      %{row: 8, col: 0},
      %{row: 7, col: 8},
      %{row: 6, col: 1},
      %{row: 4, col: 7},
      %{row: 3, col: 2},
      %{row: 1, col: 9},
      %{row: 0, col: 4}
    ]

    state = %{player: %{loc: %{row: 6, col: 4}, dir: "^"}, obstructions: obstructions}
    updated = Day6.next_move(state)
    assert 5 == updated.player.loc.row
    assert 4 == updated.player.loc.col
    assert "^" == updated.player.dir

    updated = Day6.next_move(updated)
    updated = Day6.next_move(updated)
    updated = Day6.next_move(updated)

    updated = Day6.next_move(updated)
    assert 1 == updated.player.loc.row
    assert 4 == updated.player.loc.col
    assert "^" == updated.player.dir

    updated = Day6.next_move(updated)
    assert 1 == updated.player.loc.row
    assert 4 == updated.player.loc.col
    assert ">" == updated.player.dir
  end

  @tag :pending
  test "run_guard" do
    input = Day6.read_input("day6test2")
    start = Day6.find_starting_positions(input)

    out = "day6testout2"
    min = 0

    Day6.print_state_file(start, out, min)

    ending = Day6.run_guard(start, out, min)

    visited = ending.visited |> MapSet.to_list()
    # assert 41 = length(visited)
    assert 5 = length(visited)

    assert Enum.any?(visited, fn x -> x.row == 5 && x.col == 0 end)
  end

  @tag :pending
  test "run_guard_for_real" do
    input = Day6.read_input("day6input")

    out = "day6realout_rest"
    min = 5200

    start = Day6.find_starting_positions(input)
    Day6.print_state_file(start, out, min)

    ending = Day6.run_guard(start, out, min)

    visited = ending.visited |> MapSet.to_list()
    assert 5129 = length(visited)

    ending
  end

  @tag :pending
  test "quick_map" do
    input = Day6.read_input("day6test2")
    start = Day6.find_starting_positions(input)

    assert "....#.....\r\n.........#\r\n..........\r\n..#.......\r\n.......#..\r\n....<.....\r\n.#........\r\n........#.\r\n#.........\r\n......#..." =
             Day6.get_print_map_quick(start, 10, 10)
  end

  @tag :pending
  test "poss_locations" do
    input = Day6.read_input("day6test")
    start = Day6.find_starting_positions(input)

    poss = Day6.poss_locations(start)
    assert length(poss) == 91
  end

  @tag :pending
  test "find_cycles" do
    input = Day6.read_input("day6test")
    start = Day6.find_starting_positions(input)

    cycle_locs = Day6.find_cycles(start, "day2test_out", 5000)
    assert length(cycle_locs) == 6
  end

  @tag :pending
  test "find_cycles_for_real" do
    input = Day6.read_input("day6input")
    start = Day6.find_starting_positions(input)

    cycle_locs = Day6.find_cycles(start, "day2_out", 5_000_000)
    assert length(cycle_locs) == 1888
  end


end
