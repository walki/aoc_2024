defmodule Day10Test do
  use ExUnit.Case

  import Day10

  test "read_input" do
    %{map: map} = read_input("day10test")

    assert [
             {0, ["8", "9", "0", "1", "0", "1", "2", "3"]},
             {1, ["7", "8", "1", "2", "1", "8", "7", "4"]},
             {2, ["8", "7", "4", "3", "0", "9", "6", "5"]},
             {3, ["9", "6", "5", "4", "9", "8", "7", "4"]},
             {4, ["4", "5", "6", "7", "8", "9", "0", "3"]},
             {5, ["3", "2", "0", "1", "9", "0", "1", "2"]},
             {6, ["0", "1", "3", "2", "9", "8", "0", "1"]},
             {7, ["1", "0", "4", "5", "6", "7", "3", "2"]}
           ] == map
  end

  test "find_trailheads" do
    input =
      """
      ...0...
      ...1...
      ...2...
      6543456
      7.....7
      8.....8
      9.....9
      """

    state = get_map(input) |> find_trailheads()
    assert [{0, 3}] = state.heads

    input2 =
      """
      10..9..
      2...8..
      3...7..
      4567654
      ...8..3
      ...9..2
      .....01
      """

    state2 = get_map(input2) |> find_trailheads()
    assert [{6, 5}, {0, 1}] = state2.heads
  end

  test "find_eligible_neighbors" do
    state = read_input("day10test") |> find_trailheads()

    assert {:ok, [{1, 2}, {0, 3}]} = find_eligible_neighbors(0, {0, 2}, state)

    assert {:ok, [{1, 3}]} = find_eligible_neighbors(1, {0, 3}, state)
    assert {:ok, [{1, 3}]} = find_eligible_neighbors(1, {1, 2}, state)
  end

  test "find_paths" do
    state = read_input("day10test") |> find_trailheads()
    assert [] = find_paths(state)
  end
end
