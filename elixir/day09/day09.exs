defmodule Day09 do
  def parse(input) do
    for line <- String.split(input, "\n", trim: true) do
      [x, y] = String.split(line, ",")
      {String.to_integer(x), String.to_integer(y)}
    end
  end

  def part1(tiles) do
    tiles
    |> pairs()
    |> Enum.map(fn {{px, py}, {qx, qy}} ->
      (abs(px - qx) + 1) * (abs(py - qy) + 1)
    end)
    |> Enum.max()
  end

  def part2(tiles) do
    adjacent =
      Enum.chunk_every(tiles ++ Enum.take(tiles, 1), 2, 1, :discard)

    floor =
      Enum.reduce(adjacent, MapSet.new(), fn
        [{x, py}, {x, qy}], floor ->
          MapSet.union(floor, MapSet.new(min(py, qy)..max(py, qy), fn y -> {x, y} end))

        [{px, y}, {qx, y}], floor ->
          MapSet.union(floor, MapSet.new(min(px, qx)..max(px, qx), fn x -> {x, y} end))
      end)

    :ok
  end

  def print(floor) do
    for y <- 0..8 do
      for x <- 0..13 do
        if {x, y} in floor do
          IO.write("X")
        else
          IO.write(".")
        end
      end

      IO.write("\n")
    end
  end

  def pairs([]), do: []

  def pairs([x | xs]) do
    for(y <- xs, do: {x, y}) ++ pairs(xs)
  end
end

tiles = Day09.parse(File.read!("example.txt"))
IO.puts(Day09.part1(tiles))
IO.puts(Day09.part2(tiles))
