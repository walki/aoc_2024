defmodule Day14Test do
  use ExUnit.Case

  import Day14

  test "read_input" do
    robots = read_input("day14test")
    assert Enum.count(robots) == 12
    assert Enum.at(robots, 0) == %{p_x: 0, p_y: 4, v_x: 3, v_y: -3}
    assert Enum.at(robots, -1) == %{p_x: 9, p_y: 5, v_x: -3, v_y: -3}
  end

  test "make_robot" do
    assert %{p_x: 0, p_y: 4, v_x: 3, v_y: -3} == make_robot("p=0,4 v=3,-3")
  end

  test "init_state" do
    robots = [%{p_x: 0, p_y: 4, v_x: 3, v_y: -3}]
    state = %{robots: robots, map_size: %{w: 11, h: 7}}

    assert state == init_state(robots, 11, 7)
  end

  test "advance_robot" do
    robot = make_robot("p=2,4 v=2,-3")
    map_size = %{w: 11, h: 7}
    advanced = advance_robot(robot, map_size)
    assert %{p_x: 4, p_y: 1, v_x: 2, v_y: -3} == advanced
    advanced = advance_robot(advanced, map_size)
    assert %{p_x: 6, p_y: 5, v_x: 2, v_y: -3} == advanced
    advanced = advance_robot(advanced, map_size)
    assert %{p_x: 8, p_y: 2, v_x: 2, v_y: -3} == advanced
    advanced = advance_robot(advanced, map_size)
    assert %{p_x: 10, p_y: 6, v_x: 2, v_y: -3} == advanced
    advanced = advance_robot(advanced, map_size)
    assert %{p_x: 1, p_y: 3, v_x: 2, v_y: -3} == advanced
  end

  @tag :pending
  test "iterate" do
    state = init_state([make_robot("p=2,4 v=2,-3")], 11, 7)
    state = iterate(state, 0, 5)
    bot = state.robots |> Enum.at(0)
    assert bot.p_x == 1
    assert bot.p_y == 3
  end

  @tag :pending
  test "run test file" do
    robots = read_input("day14test")
    state = init_state(robots, 11, 7)
    run = iterate(state, 0, 100)
    found = find_quads(run)

    assert [
             %{p_x: 3, p_y: 5, v_x: 3, v_y: -3, quad: :three},
             %{p_x: 5, p_y: 4, v_x: -1, v_y: -3, quad: :middle},
             %{p_x: 9, p_y: 0, v_x: -1, v_y: 2, quad: :two},
             %{p_x: 4, p_y: 5, v_x: 2, v_y: -1, quad: :three},
             %{p_x: 1, p_y: 6, v_x: 1, v_y: 3, quad: :three},
             %{p_x: 1, p_y: 3, v_x: -2, v_y: -2, quad: :middle},
             %{p_x: 6, p_y: 0, v_x: -1, v_y: -3, quad: :two},
             %{p_x: 2, p_y: 3, v_x: -1, v_y: -2, quad: :middle},
             %{p_x: 0, p_y: 2, v_x: 2, v_y: 3, quad: :one},
             %{p_x: 6, p_y: 0, v_x: -1, v_y: 2, quad: :two},
             %{p_x: 4, p_y: 5, v_x: 2, v_y: -3, quad: :three},
             %{p_x: 6, p_y: 6, v_x: -3, v_y: -3, quad: :four}
           ] == found.robots

    assert 12 == safety_factor(found)
  end

  @tag :pending
  test "run input file" do
    sf =
      read_input("day14input")
      |> init_state(101, 103)
      |> iterate(0, 100)
      |> find_quads()
      |> safety_factor()

    assert sf == 230_686_500
  end

  test "part two find the xmas tree" do
    read_input("day14input")
    |> init_state(101, 103)
    |> iterate(0, 50_000)

    # IO.puts(print_state(state))
  end
end
