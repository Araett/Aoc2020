defmodule Aoc.Day10 do
  def read_file(pathname) do
    {:ok, contents} = File.read(pathname)
    contents
  end

  def split_lines(data), do: data |> String.split("\n", trim: true)

  def part1(pathname) do
    pathname
    |> read_file
    |> split_lines
    |> Enum.map(&String.to_integer(&1))
    |> get_differences_chain
    |> Enum.reduce(Map.new(), &Aoc.Day6.map_key_reduce/2)
    |> get_answer_part1
  end

  def part2(pathname) do
    pathname
    |> read_file
    |> split_lines
    |> Enum.map(&String.to_integer(&1))
    |> get_differences_chain
    |> get_ambigious_connections
    |> Enum.reduce(Map.new(), &Aoc.Day6.map_key_reduce/2)
  end

  defp get_differences_chain(list) do
    list
    |> add_initial_output
    |> add_builtin_adapter
    |> Enum.sort()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&List.to_tuple(&1))
    |> Enum.map(&get_difference(&1))
  end

  defp get_ambigious_connections(chain) do
    Enum.reduce(chain, "", fn ele, acc -> acc <> Integer.to_string(ele) end)
    |> String.split("3", trim: true)
    |> Enum.map(&String.length(&1))
  end

  # TODO Binary combination table

  defp get_answer_part1(map), do: map[1] * map[3]

  defp add_initial_output(list), do: [0 | list]

  defp add_builtin_adapter(list), do: [Enum.max(list) + 3 | list]

  defp get_difference({x1, x2}), do: abs(x1 - x2)
end
