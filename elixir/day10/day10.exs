defmodule Day10 do
  import Bitwise

  def parse(input) do
    for line <- String.split(input, "\n", trim: true), 1 do
      [lights] = ~r/\[([^\]]+)\]/ |> Regex.run(line, capture: :all_but_first)
      buttons = ~r/\(([^)]+)\)/ |> Regex.scan(line, capture: :all_but_first) |> List.flatten()
      [joltage] = ~r/{([^}]+)}/ |> Regex.run(line, capture: :all_but_first)

      lights =
        lights
        |> to_charlist()
        |> Enum.map(fn
          ?. -> 0
          ?# -> 1
        end)
        |> Enum.reverse()
        |> Integer.undigits(2)

      buttons =
        buttons
        |> Enum.map(fn button ->
          button
          |> String.split(",")
          |> Enum.reduce(0, fn number, mask ->
            bor(mask, 2 ** String.to_integer(number))
          end)
        end)

      joltage = joltage |> String.split(",") |> Enum.map(&String.to_integer/1)

      {lights, buttons, joltage}
    end
  end

  def part1(manual) do
    for {lights, buttons, _joltage} <- manual do
      queue = :queue.from_list([{0, 0, nil}])
      bfs(queue, lights, buttons)
    end
    |> Enum.sum()
  end

  def bfs(queue, target_lights, buttons) do
    {{:value, {lights, num_presses, last_button}}, rest} = :queue.out(queue)

    if lights == target_lights do
      num_presses
    else
      queue =
        Enum.reduce(buttons, rest, fn button, queue ->
          if button == last_button do
            queue
          else
            :queue.in({bxor(lights, button), num_presses + 1, button}, queue)
          end
        end)

      bfs(queue, target_lights, buttons)
    end
  end
end

manual = Day10.parse(File.read!("input.txt"))
IO.inspect(Day10.part1(manual))
