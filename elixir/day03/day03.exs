defmodule Day03 do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line |> String.to_integer() |> Integer.digits()
    end)
  end

  def part1(banks) do
    banks
    |> Enum.map(fn bank ->
      max_a = bank |> Enum.drop(-1) |> Enum.max()
      idx_a = Enum.find_index(bank, &(&1 == max_a))
      max_b = bank |> Enum.drop(idx_a + 1) |> Enum.max()
      max_a * 10 + max_b
    end)
    |> Enum.sum()
  end

  def part2(banks) do
    banks
    |> Enum.map(fn bank ->
      {_bank, batteries} =
        Enum.reduce(-11..0, {bank, []}, fn i, {bank, batteries} ->
          max = bank |> Enum.drop(i) |> Enum.max()
          idx = Enum.find_index(bank, &(&1 == max))
          {Enum.drop(bank, idx + 1), [max | batteries]}
        end)

      batteries
      |> Enum.reverse()
      |> Integer.undigits()
    end)
    |> Enum.sum()
  end
end

input = Day03.parse(File.read!("input.txt"))
IO.puts(Day03.part1(input))
IO.puts(Day03.part2(input))
