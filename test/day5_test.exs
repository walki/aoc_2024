defmodule Day5Test do
  use ExUnit.Case

  @tag :pending
  test "find_rules" do
    input = """
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13

    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
    """

    rules = Day5.find_rules(input)
    assert 21 == length(rules)
    assert {47, 53} == rules |> Enum.at(0)
    assert {53, 13} == rules |> Enum.at(-1)
  end

  @tag :pending
  test "find updates" do
    input = Day5.read_input("day5test")

    updates = Day5.find_updates(input)

    assert 6 == length(updates)
    assert [75, 47, 61, 53, 29] == updates |> Enum.at(0)
    assert [97, 13, 75, 29, 47] == updates |> Enum.at(-1)
  end

  @tag :pending
  test "check_update" do
    {rules, updates} = Day5.get_rules_and_updates("day5test")

    assert Day5.check_update(Enum.at(updates, 0), rules)
  end

  @tag :pending
  test "solve part 1 test" do
    {rules, updates} = Day5.get_rules_and_updates("day5test")
    assert 143 == Day5.solve_part1(updates, rules)
  end

  @tag :pending
  test "solve part 1" do
    {rules, updates} = Day5.get_rules_and_updates("day5input")
    assert 5108 == Day5.solve_part1(updates, rules)
  end

  @tag :pending
  test "find_incorrect" do
    {rules, updates} = Day5.get_rules_and_updates("day5test")

    assert [[75, 97, 47, 61, 53], [61, 13, 29], [97, 13, 75, 29, 47]] ==
             Day5.find_incorrect(updates, rules)
  end

  @tag :pending
  test "find_error_rules" do
    {rules, updates} = Day5.get_rules_and_updates("day5test")

    assert [{97, 75}] == Day5.find_error_rules([75, 97, 47, 61, 53], rules)
  end

  @tag :pending
  test "move_second" do
    assert [97, 75, 47, 61, 53] ==
             Day5.move_second_after_first([75, 97, 47, 61, 53], {97, 75})
  end

  @tag :pending
  test "solve part 2 test" do
    {rules, updates} = Day5.get_rules_and_updates("day5test")

    # assert [[97,75,47,61,53],[61,29,13],[97,75,47,29,13]] == Day5.solve_part2(updates, rules)
    assert 123 == Day5.solve_part2(updates, rules)
  end

  @tag :pending
  test "solve part 2" do
    {rules, updates} = Day5.get_rules_and_updates("day5input")

    assert 7380 == Day5.solve_part2(updates, rules)
  end
end
