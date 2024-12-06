defmodule Day5 do
  def read_input(name) do
    File.read!("./input/#{name}")
  end

  def find_rules(input) do
    input
    |> String.split("\r\n", trim: true)
    |> Enum.filter(&String.match?(&1, ~r/\d+\|\d+/))
    |> Enum.map(&parse_rule/1)
  end

  def parse_rule(rule) do
    [_, f, s] = Regex.run(~r/(\d+)\|(\d+)/, rule)
    {first, _} = Integer.parse(f)
    {second, _} = Integer.parse(s)
    {first, second}
  end

  def find_updates(input) do
    input
    |> String.split("\r\n", trim: true)
    |> Enum.filter(fn x -> String.match?(x, ~r/\d+\|\d+/) == false end)
    |> Enum.map(&parse_update/1)
  end

  def parse_update(update) do
    update
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end

  def get_rules_and_updates(name) do
    input = read_input(name)

    rules = find_rules(input)
    updates = find_updates(input)
    {rules, updates}
  end

  def proper_order?({f, s} = _rule, update) do
    f_i = Enum.find_index(update, fn x -> x == f end)
    s_i = Enum.find_index(update, fn x -> x == s end)
    order?(f_i, s_i)
  end

  def order?(nil, _), do: true
  def order?(_, nil), do: true
  def order?(f, s) when f < s, do: true
  def order?(_, _), do: false

  def check_update(update, rules) do
    rules
    |> Enum.map(&proper_order?(&1, update))
    |> Enum.all?()
  end

  def solve_part1(updates, rules) do
    updates
    |> Enum.map(fn update ->
      in_order = check_update(update, rules)
      find_middle(in_order, update)
    end)
    |> Enum.sum()
  end

  def find_middle(false = _in_order, _), do: 0

  def find_middle(_, update) do
    mid_idx = length(update) |> Integer.floor_div(2)
    Enum.at(update, mid_idx)
  end

  # part 2

  def find_incorrect(updates, rules) do
    updates
    |> Enum.reduce([], fn upd, acc ->
      case check_update(upd, rules) do
        true -> acc
        false -> acc ++ [upd]
      end
    end)
  end

  def find_error_rules(update, rules) do
    rules
    |> Enum.reduce([], fn rule, acc ->
      case proper_order?(rule, update) do
        true -> acc
        false -> acc ++ [rule]
      end
    end)
  end

  def move_second_after_first(update, {f, s}) do
    f_i = Enum.find_index(update, fn x -> x == f end)
    s_i = Enum.find_index(update, fn x -> x == s end)

    upto_s =
      case s_i == 0 do
        true -> []
        false -> Enum.slice(update, 0..(s_i - 1))
      end

    upto_f = Enum.slice(update, (s_i + 1)..f_i)
    rest = Enum.slice(update, (f_i + 1)..length(update))
    upto_s ++ upto_f ++ [s] ++ rest
  end

  def do_fixes(update, [], _rules), do: update

  def do_fixes(update, [error | _rest], rules) do
    updated = move_second_after_first(update, error)
    maybe_fixed(updated, rules)
  end

  def maybe_fixed(update, rules) do
    case find_error_rules(update, rules) do
      [] -> update
      new_errors -> do_fixes(update, new_errors, rules)
    end
  end

  def solve_part2(updates, rules) do
    Day5.find_incorrect(updates, rules)
    |> Enum.map(fn incorrect ->
      errors = find_error_rules(incorrect, rules)
      do_fixes(incorrect, errors, rules)
    end)
    |> Enum.map(&find_middle(true, &1))
    |> Enum.sum()
  end
end
