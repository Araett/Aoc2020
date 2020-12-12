defmodule Aoc.Day11 do
  def transform_to_coord_map(list) do
    Map.new(
      for x <- 0..(length(Enum.at(list, 0)) - 1),
          y <- 0..(length(list) - 1),
          do: {
            {x, y},
            Enum.at(Enum.at(list, y), x)
          }
    )
  end

  def part1(pathname, threshold) do
    pathname
    |> Aoc.Day1.read_file()
    |> Aoc.Day1.split_lines()
    |> Enum.map(&String.graphemes(&1))
    |> transform_to_coord_map
    |> run_till_stabilization(%{}, &part1_rule/4, threshold)
    |> Map.values()
    |> Enum.count(&(&1 == "#"))
  end

  def part2(pathname, threshold) do
    pathname
    |> Aoc.Day1.read_file()
    |> Aoc.Day1.split_lines()
    |> Enum.map(&String.graphemes(&1))
    |> transform_to_coord_map
    |> run_till_stabilization(%{}, &part2_rule/4, threshold)
    |> Map.values()
    |> Enum.count(&(&1 == "#"))
  end

  defp run_till_stabilization(map, map, _, _), do: map

  defp run_till_stabilization(map, _, rule_func, threshold) do
    # output_coord_map(map)
    new_map = new_generation(map, rule_func, threshold)
    run_till_stabilization(new_map, map, rule_func, threshold)
  end

  defp new_generation(map, rule_func, threshold) do
    Map.keys(map)
    |> Enum.map(&rule_func.(map, &1, "#", threshold))
    |> Map.new()
  end

  defp part1_rule(map, cord, neighbour, threshold) do
    count_neighbours(map, cord, neighbour, map[cord]) |> apply_rule(map[cord], cord, threshold)
  end

  defp part2_rule(map, cord, neighbour, threshold) do
    count_visible_seats(map, cord, neighbour, map[cord]) |> apply_rule(map[cord], cord, threshold)
  end

  defp apply_rule(_, ".", coord, _), do: {coord, "."}
  defp apply_rule(count, field, coord, threshold), do: {coord, rule(field, count, threshold)}

  defp rule("#", count, threshold) when count >= threshold, do: "L"
  defp rule("L", count, _) when count == 0, do: "#"
  defp rule(field, _, _), do: field

  defp count_neighbours(_, _, _, "."), do: 0

  defp count_neighbours(map, {x, y}, neighbour, _) do
    for(
      n <- (x - 1)..(x + 1),
      m <- (y - 1)..(y + 1),
      {n, m} != {x, y},
      do: Map.get(map, {n, m}, ".") == neighbour
    )
    |> Enum.count(& &1)
  end

  defp count_visible_seats(_, _, _, "."), do: 0

  defp count_visible_seats(map, {x, y}, neighbour, _) do
    for(n <- -1..1, m <- -1..1, {n, m} != {0, 0}, do: {n, m})
    |> Enum.map(&traverse(map, ".", &1, {x, y}, neighbour))
    |> Enum.count(& &1)
  end

  defp traverse(_, "L", _, _, _), do: false
  defp traverse(_, nil, _, _, _), do: false
  defp traverse(_, neighbour, _, _, neighbour), do: true

  defp traverse(map, _, {dir_x, dir_y}, {x, y}, neighbour) do
    traverse(map, map[{x + dir_x, y + dir_y}], {dir_x, dir_y}, {x + dir_x, y + dir_y}, neighbour)
  end

  defp output_coord_map(map) do
    coords = Map.keys(map)
    x_max = Enum.max(Enum.map(coords, &elem(&1, 0)))
    y_max = Enum.max(Enum.map(coords, &elem(&1, 1)))
    list = for y <- 0..y_max, x <- 0..x_max, do: map[{x, y}]

    Enum.chunk_every(list, x_max + 1)
    |> Enum.map(&Enum.join(&1))
    |> Enum.each(&IO.puts(&1))

    IO.puts("-------------------------------------")
  end
end
