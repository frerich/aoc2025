defmodule Day06 do
  def part1(input) do
    worksheet =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split/1)
      |> transpose()
      |> Enum.map(fn column ->
        {numbers, [operator]} = Enum.split(column, -1)
        {Enum.map(numbers, &String.to_integer/1), operator}
      end)

    solve(worksheet)
  end

  def part2(input) do
    {number_lines, [operator_line]} =
      input
      |> String.split("\n", trim: true)
      |> Enum.split(-1)

    rotated_numbers =
      number_lines
      |> Enum.map(&to_charlist/1)
      |> transpose()
      |> Enum.chunk_by(fn chars -> Enum.all?(chars, &(&1 == ?\s)) end)
      |> Enum.reject(fn row -> length(row) == 1 end)
      |> Enum.map(fn row ->
        Enum.map(row, fn cell -> cell |> to_string() |> String.trim() end)
      end)

    operators = String.split(operator_line)

    worksheet =
      Enum.zip_with(rotated_numbers, operators, fn numbers, operator ->
        {Enum.map(numbers, &String.to_integer/1), operator}
      end)

    solve(worksheet)
  end

  defp transpose(list) do
    list |> Enum.zip() |> Enum.map(&Tuple.to_list/1)
  end

  defp solve(worksheet) do
    worksheet
    |> Enum.map(fn
      {numbers, "*"} -> Enum.product(numbers)
      {numbers, "+"} -> Enum.sum(numbers)
    end)
    |> Enum.sum()
  end
end

input = File.read!("input.txt")
IO.puts(Day06.part1(input))
IO.puts(Day06.part2(input))
