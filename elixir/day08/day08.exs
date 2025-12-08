defmodule Day08 do
  def parse(input) do
    for line <- String.split(input, "\n", trim: true) do
      [x, y, z] = String.split(line, ",")
      %{x: String.to_integer(x), y: String.to_integer(y), z: String.to_integer(z)}
    end
  end

  def part1(boxes) do
    circuits = boxes |> Enum.with_index() |> Map.new()

    circuits =
      boxes
      |> pairs()
      |> Enum.sort_by(fn {box_a, box_b} -> distance(box_a, box_b) end)
      |> Enum.take(1000)
      |> Enum.reduce(circuits, fn {box_a, box_b}, circuits ->
        %{
          ^box_a => circuit_a,
          ^box_b => circuit_b
        } = circuits

        if circuit_a == circuit_b do
          circuits
        else
          merge(circuits, circuit_a, circuit_b)
        end
      end)

    circuits
    |> Enum.group_by(fn {_box, circuit} -> circuit end)
    |> Map.values()
    |> Enum.map(&length/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  def part2(boxes) do
    circuits = boxes |> Enum.with_index() |> Map.new()

    {box_a, box_b} =
      boxes
      |> pairs()
      |> Enum.sort_by(fn {box_a, box_b} -> distance(box_a, box_b) end)
      |> Enum.reduce_while(circuits, fn {box_a, box_b}, circuits ->
        %{
          ^box_a => circuit_a,
          ^box_b => circuit_b
        } = circuits

        cond do
          circuit_a == circuit_b ->
            {:cont, circuits}

          length(Enum.uniq(Map.values(circuits))) == 2 ->
            {:halt, {box_a, box_b}}

          true ->
            {:cont, merge(circuits, circuit_a, circuit_b)}
        end
      end)

    box_a.x * box_b.x
  end

  def merge(circuits, circuit_a, circuit_b) do
    Map.new(
      circuits,
      fn
        {box, ^circuit_b} -> {box, circuit_a}
        circuit -> circuit
      end
    )
  end

  def pairs([]), do: []

  def pairs([x | xs]) do
    for(y <- xs, do: {x, y}) ++ pairs(xs)
  end

  def distance(p, q) do
    # Could omit `:math.sqrt/1`.
    :math.sqrt(:math.pow(p.x - q.x, 2) + :math.pow(p.y - q.y, 2) + :math.pow(p.z - q.z, 2))
  end
end

boxes = Day08.parse(File.read!("input.txt"))
IO.puts(Day08.part1(boxes))
IO.puts(Day08.part2(boxes))
