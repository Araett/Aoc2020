defmodule Aoc.Day3 do
  def read_file(pathname) do
    {:ok, contents} = File.read(pathname)
    contents
  end

  def split_lines(data), do: data |> String.split("\n", trim: true)

  def part1(pathname) do
    pathname
    |> read_file
    |> split_lines
    |> Enum.map(fn x -> String.graphemes(x) end)
    |> travel(x: 3, y: 1)
  end

  def part2(pathname) do
    vectors = [
      [x: 1, y: 1],
      [x: 3, y: 1],
      [x: 5, y: 1],
      [x: 7, y: 1],
      [x: 1, y: 2]
    ]

    map =
      pathname
      |> read_file
      |> split_lines
      |> Enum.map(fn x -> String.graphemes(x) end)

    Enum.map(vectors, fn x -> travel(map, x) end)
    |> Enum.reduce(fn count, product -> product * count end)
  end

  defp is_tree?(field) when field == "#", do: 1
  defp is_tree?(_field), do: 0

  defp count_trees(_, _, cur_y, _, max_y, _) when cur_y >= max_y, do: 0

  defp count_trees(map, cur_x, cur_y, max_x, max_y, vector) do
    is_tree?(Enum.at(Enum.at(map, cur_y), cur_x)) +
      count_trees(map, rem(cur_x + vector[:x], max_x), cur_y + vector[:y], max_x, max_y, vector)
  end

  defp travel(map, vector) do
    max_y = length(map)
    max_x = length(List.first(map))
    count_trees(map, 0, 0, max_x, max_y, vector)
  end
end
