defmodule Day05 do
  def parse(input) do
    [range_section, ids_section] = String.split(input, "\n\n")

    ranges =
      for line <- String.split(range_section, "\n") do
        [from, to] = String.split(line, "-")
        String.to_integer(from)..String.to_integer(to)
      end

    ids =
      for line <- String.split(ids_section, "\n", trim: true) do
        String.to_integer(line)
      end

    {ranges, ids}
  end

  def part1({ranges, ids}) do
    Enum.count(ids, fn id ->
      Enum.any?(ranges, fn range -> id in range end)
    end)
  end

  def part2({ranges, _ids}) do
    [first | rest] = Enum.sort_by(ranges, fn from.._to//_ -> from end)

    rest
    |> Enum.reduce([first], fn range, [cur | rest] ->
      if Range.disjoint?(range, cur) do
        [range, cur | rest]
      else
        cur_from..cur_to//_ = cur
        range_from..range_to//_ = range
        merged = min(cur_from, range_from)..max(cur_to, range_to)
        [merged | rest]
      end
    end)
    |> Enum.map(&Range.size/1)
    |> Enum.sum()
  end
end

input = Day05.parse(File.read!("input.txt"))
IO.puts(Day05.part1(input))
IO.puts(Day05.part2(input))
