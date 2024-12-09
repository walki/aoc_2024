defmodule Day8Test do
  use ExUnit.Case

  import Day8

  test "read_input" do
    input = read_input("day8test")

    assert %{
             map: [
               "............",
               "........0...",
               ".....0......",
               ".......0....",
               "....0.......",
               "......A.....",
               "............",
               "............",
               "........A...",
               ".........A..",
               "............",
               "............"
             ]
           } == input

    updated = find_antennas(input)

    antennas_A = Map.get(updated.antennas, "A")
    assert %{r: 5, c: 6} in antennas_A
  end

  test "find_antinodes" do
    loc1 = %{r: 3, c: 4}
    loc2 = %{r: 5, c: 5}
    antinode1 = %{r: 1, c: 3}
    _antinode2 = %{r: 7, c: 6}

    assert [antinode1] == find_antinodes(loc1, loc2, 6, 6)
  end

  test "find_all_antinodes" do
    state = %{map: [
      "............",
      "........0...",
      ".....0......",
      ".......0....",
      "....0.......",
      "......A.....",
      "............",
      "............",
      "........A...",
      ".........A..",
      "............",
      "............"
    ]}


    loc1 = %{r: 3, c: 4}
    loc2 = %{r: 5, c: 5}
    loc3 = %{r: 4, c: 8}

    antinode1 = %{r: 1, c: 3}
    antinode2 = %{r: 7, c: 6}
    antinode3 = %{r: 2, c: 0}
    antinode4 = %{r: 6, c: 2}

    ans = find_all_antinodes([loc1, loc2, loc3], state)
    assert antinode1 in ans
    assert antinode2 in ans
    assert antinode3 in ans
    assert antinode4 in ans
  end

  test "find_antinodes_for_antenna" do
    input = read_input("day8test")
    updated = find_antennas(input)

    assert 14 == find_antinodes_for_antenna(updated)
  end

  test "find_antinodes_for_antenna real" do
    input = read_input("day8input")
    updated = find_antennas(input)

    assert 318 == find_antinodes_for_antenna(updated)
  end
end
