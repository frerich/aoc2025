defmodule Day01 do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn
      <<"L", distance::binary>> -> {:left, String.to_integer(distance)}
      <<"R", distance::binary>> -> {:right, String.to_integer(distance)}
    end)
  end

  def part1(rotations) do
    rotations
    |> Enum.reduce([50], fn {direction, distance}, [dial | _] = seen ->
      steps = rotate(dial, distance, direction)
      [List.last(steps) | seen]
    end)
    |> Enum.count(&(&1 == 0))
  end

  def part2(rotations) do
    {_dial, clicks} =
      rotations
      |> Enum.reduce({50, 0}, fn {direction, distance}, {dial, clicks} ->
        steps = rotate(dial, distance, direction)
        {List.last(steps), clicks + Enum.count(steps, &(&1 == 0))}
      end)

    clicks
  end

  def rotate(dial, distance, :right) when distance >= 1 do
    Enum.map((dial + 1)..(dial + distance), fn i -> rem(i, 100) end)
  end

  def rotate(dial, distance, :left) when distance >= 1 do
    Enum.map((dial - 1)..(dial - distance)//-1, fn i ->
      r = rem(i, 100)

      if r < 0 do
        100 + r
      else
        r
      end
    end)
  end
end

input = Day01.parse(File.read!("input.txt"))
IO.puts(Day01.part1(input))
IO.puts(Day01.part2(input))
