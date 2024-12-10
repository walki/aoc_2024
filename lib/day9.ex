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
end
