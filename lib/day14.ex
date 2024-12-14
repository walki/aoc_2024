defmodule Day14 do
  def read_input(name) do
    File.read!("./input/#{name}")
    |> String.split("\r\n", trim: true)
    |> Enum.map(&make_robot/1)
  end

  def make_robot(line) do
    [_, p_x, p_y, v_x, v_y] =
      Regex.run(~r/p=(-{0,1}\d+),(-{0,1}\d+) v=(-{0,1}\d+),(-{0,1}\d+)/, line)

    %{
      p_x: String.to_integer(p_x),
      p_y: String.to_integer(p_y),
      v_x: String.to_integer(v_x),
      v_y: String.to_integer(v_y)
    }
  end

  def init_state(robots, width, height),
    do: %{robots: robots, map_size: %{w: width, h: height}}

  @spec advance_robot(
          %{
            :p_x => integer(),
            :p_y => integer(),
            :v_x => integer(),
            :v_y => integer(),
            optional(any()) => any()
          },
          %{:h => integer(), :w => integer(), optional(any()) => any()}
        ) :: %{p_x: integer(), p_y: integer(), v_x: integer(), v_y: integer()}
  def advance_robot(%{p_x: p_x, p_y: p_y, v_x: v_x, v_y: v_y}, %{w: w, h: h}) do
    x = Integer.mod(p_x + v_x, w)
    y = Integer.mod(p_y + v_y, h)
    %{p_x: x, p_y: y, v_x: v_x, v_y: v_y}
  end

  def iterate(state, last, last), do: state

  def iterate(%{robots: bots, map_size: size}, curr, last) do
    advanced =
      bots
      |> Enum.map(&advance_robot(&1, size))
      |> Enum.sort(fn x, y -> x.p_y < y.p_y end)

    adv_state = %{robots: advanced, map_size: size}
    adv_curr = curr + 1
    check_contenda(adv_state, adv_curr, adv_state)

    iterate(adv_state, adv_curr, last)
  end

  def check_contenda(%{robots: bots}, adv_curr, state) do
    check =
      Range.to_list(0..5)
      |> Enum.map(fn x -> Enum.any?(bots, fn b -> check_bot(b, state.map_size, x) end) end)
      |> Enum.all?()

    case check do
      true ->
        IO.puts("We got at contenda: #{adv_curr}")
        print_file(adv_curr, state)

      false ->
        nil
    end
  end

  def check_bot(%{p_x: x, p_y: y}, %{w: w}, row_num) when x == div(w, 2) - y and y == row_num,
    do: true

  def check_bot(%{p_x: x, p_y: y}, %{w: w}, row_num) when x == div(w, 2) + y and y == row_num,
    do: true

  def check_bot(%{p_x: _x, p_y: _y}, %{w: _w}, _), do: false

  def check_bot_0(%{p_x: x, p_y: y}) when x == 50 and y == 0, do: true
  def check_bot_0(_), do: false

  def check_bot_1(%{p_x: x, p_y: y}) when (x == 49 or x == 51) and y == 1, do: true
  def check_bot_1(_), do: false

  def check_bot_2(%{p_x: x, p_y: y}) when (x == 48 or x == 52) and y == 2, do: true
  def check_bot_2(_), do: false

  def print_file(adv_curr, _) when adv_curr < 100_000, do: nil

  def print_file(adv_curr, state) do
    file_name = "day14-#{adv_curr}"
    {:ok, file} = File.open("./output/day14/#{file_name}.txt", [:write])

    IO.puts(
      file,
      "Current Sec: #{adv_curr} ------------------------------------------------------------------------------"
    )

    IO.puts(file, print_state(state))

    File.close(file)
  end

  def print(adv_curr, state) do
    IO.puts("")

    IO.puts(
      "Current Sec: #{adv_curr} ------------------------------------------------------------------------------"
    )

    IO.puts(print_state(state))

    IO.puts(
      "----------------------------------------------------------------------------------------------------------------"
    )

    IO.gets("Enter for next image")
  end

  def find_quads(%{robots: bots, map_size: size} = state) do
    found =
      bots
      |> Enum.map(fn r ->
        quad = find_quad(r, size)
        Map.put(r, :quad, quad)
      end)

    Map.put(state, :robots, found)
  end

  def find_quad(%{p_x: x, p_y: y}, %{w: w, h: h}) when x == div(w, 2) or y == div(h, 2),
    do: :middle

  def find_quad(%{p_x: x, p_y: y}, %{w: w, h: h}) when x < div(w, 2) and y < div(h, 2), do: :one
  def find_quad(%{p_x: x, p_y: y}, %{w: w, h: h}) when x > div(w, 2) and y < div(h, 2), do: :two
  def find_quad(%{p_x: x, p_y: y}, %{w: w, h: h}) when x < div(w, 2) and y > div(h, 2), do: :three
  def find_quad(%{p_x: x, p_y: y}, %{w: w, h: h}) when x > div(w, 2) and y > div(h, 2), do: :four

  def safety_factor(%{robots: bots}) do
    one = bots |> Enum.count(fn b -> b.quad == :one end)
    two = bots |> Enum.count(fn b -> b.quad == :two end)
    three = bots |> Enum.count(fn b -> b.quad == :three end)
    four = bots |> Enum.count(fn b -> b.quad == :four end)
    # middle = bots |> Enum.count(fn b -> b.quad == :middle end)
    [one, two, three, four] |> Enum.product()
  end

  def print_state(%{robots: bots, map_size: %{w: w, h: h}}) do
    map = String.duplicate(".", w * h)

    bots
    |> Enum.reduce(map, fn %{p_x: x, p_y: y}, map ->
      replace(map, y, x, w, "*")
    end)
    |> String.graphemes()
    |> Enum.chunk_every(w)
    |> Enum.map(&Enum.join/1)
    |> Enum.map(fn l -> l <> "\r\n" end)
    |> Enum.join()
  end

  def replace(str, r, c, rl, ch) do
    idx = r * rl + c
    before_i = String.slice(str, 0, idx)
    after_i = String.slice(str, idx + 1, String.length(str))
    before_i <> ch <> after_i
  end
end
