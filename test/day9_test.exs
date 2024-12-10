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

  test "realsy" do
    files = get_files("day9input")
    assert 6_201_130_364_722 == checksum(files)
  end
end
