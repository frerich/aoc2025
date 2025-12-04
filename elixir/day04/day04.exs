defmodule Day04 do
  def parse(input) do
    for {line, y} <- Enum.with_index(String.split(input, "\n", trim: true)),
        {?@, x} <- Enum.with_index(to_charlist(line)) do
      {x, y}
    end
  end

  def part1(rolls) do
    rolls = MapSet.new(rolls)
    Enum.count(rolls, fn roll -> accessible?(rolls, roll) end)
  end

  def part2(rolls) do
    rolls = MapSet.new(rolls)
    trimmed = remove_all(rolls)
    Enum.count(rolls) - Enum.count(trimmed)
  end

  def remove_all(rolls) do
    case Enum.filter(rolls, fn roll -> accessible?(rolls, roll) end) do
      [] ->
        rolls

      to_remove ->
        remove_all(MapSet.difference(rolls, MapSet.new(to_remove)))
    end
  end

  def accessible?(rolls, {x, y}) do
    neighbors =
      [
        {-1, -1}, {0, -1}, {1, -1},
        {-1,  0},          {1,  0},
        {-1,  1}, {0,  1}, {1,  1}
      ]

    Enum.count(neighbors, fn {dx, dy} -> {x + dx, y + dy} in rolls end) < 4
  end
end

input = Day04.parse(File.read!("input.txt"))
IO.puts(Day04.part1(input))
IO.puts(Day04.part2(input))
