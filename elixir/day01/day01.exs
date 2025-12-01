defmodule Day01 do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn
      <<"L", distance::binary>> -> -1 * String.to_integer(distance)
      <<"R", distance::binary>> -> String.to_integer(distance)
    end)
  end

  def part1(rotations) do
    rotations
    |> Enum.reduce([50], fn distance, [dial | _] = seen ->
      r = rem(dial + distance, 100)

      new_dial = if r < 0, do: 100 + r, else: r

      [new_dial | seen]
    end)
    |> Enum.count(&(&1 == 0))
  end

  def part2(rotations) do
    {_dial, clicks} =
      rotations
      |> Enum.reduce({50, 0}, fn distance, {dial, clicks} ->
        x = dial + distance
        r = rem(x, 100)

        new_dial = if r < 0, do: 100 + r, else: r

        new_clicks =
          if x <= 0 and dial > 0 do
            1 + abs(div(x, 100))
          else
            abs(div(x, 100))
          end

        {new_dial, clicks + new_clicks}
      end)

    clicks
  end
end

input = Day01.parse(File.read!("input.txt"))
IO.puts(Day01.part1(input))
IO.puts(Day01.part2(input))
