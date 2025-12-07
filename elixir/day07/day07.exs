defmodule Day07 do
  def parse(input) do
    [first | lines] = String.split(input, "\n", trim: true)

    start = Enum.find_index(to_charlist(first), &(&1 == ?S))

    diagram =
      for line <- lines do
        for {?^, x} <- Enum.with_index(to_charlist(line)) do
          x
        end
      end

    {start, diagram}
  end

  def part1({start, diagram}) do
    {num_splits, _beams} =
      Enum.reduce(diagram, {0, [start]}, fn splitters, {num_splits, beams} ->
        {splits, passes} = Enum.split_with(beams, &(&1 in splitters))

        beams = Enum.flat_map(splits, &[&1 - 1, &1 + 1])

        {num_splits + length(splits), Enum.uniq(beams ++ passes)}
      end)

    num_splits
  end

  def part2({start, diagram}) do
    {paths, _memo} = step(diagram, start, 0, %{})
    paths
  end

  def step([], _beam, _depth, memo) do
    {1, memo}
  end

  def step([splitters | rest], beam, depth, memo) do
    case memo[{beam, depth}] do
      nil ->
        if beam in splitters do
          {paths_left, memo} = step(rest, beam - 1, depth + 1, memo)
          {paths_right, memo} = step(rest, beam + 1, depth + 1, memo)
          memo = Map.put(memo, {beam, depth}, paths_left + paths_right)
          {paths_left + paths_right, memo}
        else
          step(rest, beam, depth + 1, memo)
        end

      num_paths ->
        {num_paths, memo}
    end
  end
end

input = Day07.parse(File.read!("input.txt"))
IO.puts(Day07.part1(input))
IO.puts(Day07.part2(input))
