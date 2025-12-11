defmodule Day11 do
  def parse(input) do
    for line <- String.split(input, "\n", trim: true), into: %{} do
      [device | outputs] = String.split(line)
      {String.trim_trailing(device, ":"), outputs}
    end
  end

  def part1(devices) do
    trace(devices, "you", MapSet.new())
  end

  # At destination - count one path.
  def trace(_devices, "out", _seen) do
    1
  end

  # At intermediate device which has further outputs: descend.
  def trace(devices, current, seen) when is_map_key(devices, current) do
    %{^current => outputs} = devices

    seen = MapSet.put(seen, current)

    outputs
    |> Enum.reject(&(&1 in seen))
    |> Enum.map(&trace(devices, &1, seen))
    |> Enum.sum()
  end

  # At intermediate device which has no outputs: dead end.
  def trace(_devices, _current, _seen) do
    0
  end
end

devices = Day11.parse(File.read!("input.txt"))
IO.puts(Day11.part1(devices))
