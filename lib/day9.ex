defmodule Day9 do
  def read_input(name) do
    File.read!("./input/#{name}")
  end

  def to_blocks(disk_map) do
    disk_map
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.zip(0..1_000_000)
    |> Enum.map(&create_block/1)
    |> List.flatten()
  end

  def create_block({[count], idx}) do
    create_block({[count, 0], idx})
  end

  def create_block({[count, free_ct], idx}) do
    List.duplicate("#{idx}", count) ++ List.duplicate(".", free_ct)
  end

  def clear_free(blocks) do
    move_from_end(blocks, [])
    |> Enum.reverse()
  end

  def move_from_end([], result), do: result
  def move_from_end([last], result), do: [last | result]

  def move_from_end(["." | rest], result) do
    {last, swapped} = swap_with_last(rest)
    move_from_end(swapped, [last | result])
  end

  def move_from_end([curr | rest], result) do
    move_from_end(rest, [curr | result])
  end

  def swap_with_last(rest) do
    idx =
      Enum.reverse(rest)
      |> Enum.find_index(fn x -> x != "." end)

    case idx do
      nil ->
        {".", rest}

      _ ->
        val =
          Enum.reverse(rest)
          |> Enum.find(fn x -> x != "." end)

        replaced =
          Enum.reverse(rest)
          |> List.replace_at(idx, ".")
          |> Enum.reverse()

        {val, replaced}
    end
  end

  def get_files(name) do
    read_input(name)
    |> to_blocks()
    |> clear_free()
  end

  def checksum(files) do
    files
    |> Enum.filter(fn x -> x != "." end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.zip(0..1_000_000)
    |> Enum.map(fn {a, b} -> a * b end)
    |> Enum.sum()
  end

  def get_files_part2(name) do
    read_input(name)
    |> to_blocks_part2()
    |> find_fit()
  end

  def to_blocks_part2(disk_map) do
    disk_map
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.zip(0..1_000_000)
    |> Enum.map(&create_block_part2/1)
    |> List.flatten()
  end

  def create_block_part2({[count], idx}) do
    create_block_part2({[count, 0], idx})
  end

  def create_block_part2({[count, free_ct], idx}) do
    [{"#{idx}", count}, {".", free_ct}]
  end

  def find_fit(blocks) do
    rev = blocks |> Enum.reverse()
    do_find_fit(rev, blocks)
  end

  def do_find_fit([], blocks), do: blocks
  def do_find_fit([{".", _size} | rest], blocks), do: do_find_fit(rest, blocks)

  def do_find_fit([{val, size} | rest], blocks) do
    free_idx = find_first_free_space(size, blocks)

    case free_idx do
      nil ->
        do_find_fit(rest, blocks)

      _ ->
        curr_idx = blocks |> Enum.find_index(fn {v, _} -> v == val end)

        case free_idx < curr_idx do
          true ->
            updated = swap_spots(blocks, free_idx, curr_idx)
            do_find_fit(rest, updated)

          _ ->
            do_find_fit(rest, blocks)
        end
    end
  end

  def find_first_free_space(size, blocks) do
    Enum.find_index(blocks, fn {val, ct} -> val == "." && ct >= size end)
  end

  def swap_spots(blocks, free_idx, curr_idx) do
    {_v, f_size} = free = Enum.at(blocks, free_idx)
    {_v, c_size} = curr = Enum.at(blocks, curr_idx)

    diff = f_size - c_size

    {curr, free} =
      case diff > 0 do
        true ->
          {[curr, {".", diff}], {".", f_size - diff}}

        _ ->
          {curr, free}
      end

    blocks
    |> List.replace_at(free_idx, curr)
    |> List.replace_at(curr_idx, free)
    |> List.flatten()
  end

  def convert_to_string(blocks) do
    blocks
    |> Enum.map(fn {v, size} ->
      String.duplicate(v, size)
    end)
    |> Enum.join()
  end

  def checksum_part2(blocks) do
    blocks
    # |> Enum.filter(fn {v, _size} -> v != "." end)
    |> Enum.map(fn
      {".", size} -> {"0", size}
      not_free -> not_free
    end)
    |> Enum.map(fn {v, size} -> List.duplicate(v, size) end)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
    |> Enum.zip(0..1_000_000)
    |> Enum.map(fn {a, b} -> a * b end)
    |> Enum.sum()
  end
end
