defmodule Aoc.Day12 do
  def part1(pathname) do
    pathname
    |> Aoc.Day1.read_file()
    |> Aoc.Day1.split_lines()
    |> Enum.map(fn x -> parse_input(x) end)
    |> travel({0, 0}, 90)
    |> Tuple.to_list()
    |> Enum.reduce(0, fn elem, acc -> acc + abs(elem) end)
  end

  def part2(pathname) do
    pathname
    |> Aoc.Day1.read_file()
    |> Aoc.Day1.split_lines()
    |> Enum.map(fn x -> parse_input(x) end)
    |> travel_waypoint({0, 0}, {10, 1})
    |> Tuple.to_list()
    |> Enum.reduce(0, fn elem, acc -> acc + abs(elem) end)
  end

  defp parse_input(input) do
    {command, value} = String.split_at(input, 1)
    {command, String.to_integer(value)}
  end

  defp travel([], cords, _), do: cords
  defp travel([{"N", value} | tail], {x, y}, degrees), do: travel(tail, {x, y + value}, degrees)
  defp travel([{"E", value} | tail], {x, y}, degrees), do: travel(tail, {x + value, y}, degrees)
  defp travel([{"W", value} | tail], {x, y}, degrees), do: travel(tail, {x - value, y}, degrees)
  defp travel([{"S", value} | tail], {x, y}, degrees), do: travel(tail, {x, y - value}, degrees)

  defp travel([{"L", value} | tail], {x, y}, degrees),
    do: travel(tail, {x, y}, rem(360 + degrees - value, 360))

  defp travel([{"R", value} | tail], {x, y}, degrees),
    do: travel(tail, {x, y}, rem(360 + degrees + value, 360))

  defp travel([{"F", value} | tail], {x, y}, degrees),
    do: travel(tail, move_to_direction({x, y}, degrees, value), degrees)

  defp move_to_direction({x, y}, 0, value), do: {x, y + value}
  defp move_to_direction({x, y}, 90, value), do: {x + value, y}
  defp move_to_direction({x, y}, 180, value), do: {x, y - value}
  defp move_to_direction({x, y}, 270, value), do: {x - value, y}

  defp travel_waypoint([], cords, _), do: cords

  defp travel_waypoint([{"N", value} | tail], cords, {wx, wy}),
    do: travel_waypoint(tail, cords, {wx, wy + value})

  defp travel_waypoint([{"E", value} | tail], cords, {wx, wy}),
    do: travel_waypoint(tail, cords, {wx + value, wy})

  defp travel_waypoint([{"W", value} | tail], cords, {wx, wy}),
    do: travel_waypoint(tail, cords, {wx - value, wy})

  defp travel_waypoint([{"S", value} | tail], cords, {wx, wy}),
    do: travel_waypoint(tail, cords, {wx, wy - value})

  defp travel_waypoint([{"L", value} | tail], cords, {wx, wy}),
    do: travel_waypoint(tail, cords, rotate_waypoint({wx, wy}, rem(360 - value, 360)))

  defp travel_waypoint([{"R", value} | tail], cords, {wx, wy}),
    do: travel_waypoint(tail, cords, rotate_waypoint({wx, wy}, rem(360 + value, 360)))

  defp travel_waypoint([{"F", value} | tail], {x, y}, {wx, wy}),
    do: travel_waypoint(tail, {x + value * wx, y + value * wy}, {wx, wy})

  defp rotate_waypoint({x, y}, 0), do: {x, y}
  defp rotate_waypoint({x, y}, 90), do: {y, -x}
  defp rotate_waypoint({x, y}, 180), do: {-x, -y}
  defp rotate_waypoint({x, y}, 270), do: {-y, x}
end
