defmodule Day02 do
  def parse(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(fn range ->
      [from, to] = String.split(range, "-")
      String.to_integer(from)..String.to_integer(to)
    end)
  end

  def part1(ranges) do
    partial_sums =
      for range <- ranges do
        range
        |> Enum.filter(fn id ->
          digits = Integer.digits(id)
          rem(Enum.count(digits), 2) == 0 and repetition?(digits, div(Enum.count(digits), 2))
        end)
        |> Enum.sum()
      end

    Enum.sum(partial_sums)
  end

  def part2(ranges) do
    partial_sums =
      for range <- ranges do
        range
        |> Enum.filter(fn id -> id > 10 end)
        |> Enum.filter(fn id ->
          digits = Integer.digits(id)

          1..div(Enum.count(digits), 2)
          |> Enum.filter(fn i -> rem(Enum.count(digits), i) == 0 end)
          |> Enum.any?(fn i -> repetition?(digits, i) end)
        end)
        |> Enum.sum()
      end

    Enum.sum(partial_sums)
  end

  def repetition?(list, length) do
    prefix = Enum.take(list, length)
    Enum.take(Stream.cycle(prefix), Enum.count(list)) == list
  end
end

input = Day02.parse(File.read!("input.txt"))
IO.puts(Day02.part1(input))
IO.puts(Day02.part2(input))
