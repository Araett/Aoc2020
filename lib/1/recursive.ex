defmodule Aoc.Day1r do
  def read_file(pathname) do
    {:ok, contents} = File.read(pathname)
    contents
  end

  def split_lines(data), do: data |> String.split("\n", trim: true)

  def print_list([]), do: IO.puts("Empty")
  def print_list(list), do: Enum.each(list, fn x -> IO.puts(x) end)

  def string_list_to_integer_list(list), do: Enum.map(list, &String.to_integer/1)

  defp layer_1(_, []), do: false

  defp layer_1(n1, [n2 | remainder]) do
    case n1 + n2 do
      2020 -> n2
      _ -> layer_1(n1, remainder)
    end
  end

  defp layer_2(_, []), do: false

  defp layer_2(n1, [n2 | remainder]) do
    case layer_1(n1 + n2, remainder) do
      false -> layer_2(n1, remainder)
      x -> n2 * x
    end
  end

  def search_for_2020([], _), do: -1

  def search_for_2020([n1 | remainder], layer) do
    case layer.(n1, remainder) do
      false -> search_for_2020(remainder, layer)
      x -> n1 * x
    end
  end

  def part1(pathname) do
    read_file(pathname)
    |> split_lines
    |> string_list_to_integer_list
    |> search_for_2020(&layer_1/2)
    |> IO.puts()
  end

  def part2(pathname) do
    read_file(pathname)
    |> split_lines
    |> string_list_to_integer_list
    |> search_for_2020(&layer_2/2)
    |> IO.puts()
  end
end
