defmodule Day9Test do
  use ExUnit.Case

  import Day9

  test "read_input" do
    assert "2333133121414131402" == read_input("day9test")
  end

  test "to_blocks" do
    assert String.split("0..111....22222", "", trim: true) == to_blocks("12345")
  end

  test "clear_free" do
    assert String.split("022111222......", "", trim: true) ==
             clear_free(String.split("0..111....22222", "", trim: true))
  end

  test "swap_with_last" do
    assert {"2", ["1", ".", "2", "2", ".", "."]} ==
             swap_with_last(["1", ".", "2", "2", "2", "."])
  end

  test "with input" do
    files = get_files("day9test")
    assert files |> Enum.join() == "0099811188827773336446555566.............."
  end

  test "checksum" do
    files = get_files("day9test")
    assert 1928 == checksum(files)
  end

  @tag :pending
  test "realsy" do
    files = get_files("day9input")
    assert 6_201_130_364_722 == checksum(files)
  end

  test "find_first_free_space" do
    blocks = [
      {"0", 2},
      {".", 3},
      {"1", 3},
      {".", 3},
      {"2", 1},
      {".", 3},
      {"3", 3},
      {".", 1},
      {"4", 2},
      # changed for the test
      {".", 8},
      {"5", 4},
      {".", 1},
      {"6", 4},
      {".", 1},
      {"7", 3},
      {".", 1},
      {"8", 4},
      {".", 0},
      {"9", 2},
      {".", 0}
    ]

    assert 1 == find_first_free_space(2, blocks)
    assert 9 == find_first_free_space(5, blocks)
    assert nil == find_first_free_space(9, blocks)
  end

  # @tag :pending
  test "part2" do
    files = get_files_part2("day9test")
    assert convert_to_string(files) == "00992111777.44.333....5555.6666.....8888.."
  end

  test "part2 checksum" do
    chksum = get_files_part2("day9test") |> checksum_part2()
    assert chksum == 2858
  end

  test "part2 checksum real" do
    chksum = get_files_part2("day9input") |> checksum_part2()
    assert chksum == 6_221_662_795_602
  end
end
