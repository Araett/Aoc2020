defmodule Aoc.Day6 do
  def read_file(pathname) do
    {:ok, contents} = File.read(pathname)
    contents
  end

  def split_lines(data), do: data |> String.split("\n", trim: true)

  def split_dataset(data), do: data |> String.split("\n\n", trim: true)

  def map_key_reduce(element, acc) do
    case is_map_key(acc, element) do
      true -> %{acc | element => acc[element] + 1}
      false -> Map.put(acc, element, 1)
    end
  end

  def part1(pathname) do
    pathname
    |> read_file
    |> split_dataset
    |> Enum.map(&split_lines(&1))
    |> Enum.map(fn x -> Enum.map(x, &String.graphemes(&1)) end)
    |> Enum.map(&List.flatten(&1))
    |> Enum.map(fn x -> Enum.reduce(x, Map.new(), &map_key_reduce/2) end)
    |> Enum.map(&Map.keys(&1))
    |> Enum.map(&Enum.count(&1))
    |> Enum.sum()
  end

  def part2(pathname) do
    pathname
    |> read_file
    |> split_dataset
    |> Enum.map(&split_lines(&1))
    |> Enum.map(fn x -> Enum.map(x, &String.graphemes(&1)) end)
    |> Enum.map(fn x -> trim_incomplete_group_answers(x, Enum.count(x)) end)
    |> Enum.map(&Map.keys(&1))
    |> Enum.map(&Enum.count(&1))
    |> Enum.sum()
  end

  defp trim_incomplete_group_answers(list, value) do
    counter =
      list
      |> List.flatten()
      |> Enum.reduce(Map.new(), &map_key_reduce/2)

    remove_keys_by_value(Map.keys(counter), counter, value)
  end

  defp remove_keys_by_value([], map, _), do: map

  defp remove_keys_by_value([key | tail], map, value) do
    case map[key] do
      ^value -> remove_keys_by_value(tail, map, value)
      _ -> remove_keys_by_value(tail, Map.delete(map, key), value)
    end
  end
end
