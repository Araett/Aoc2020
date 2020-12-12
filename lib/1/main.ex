defmodule Aoc.Day1 do
  def read_file(pathname) do
    {:ok, contents} = File.read(pathname)
    contents
  end

  def split_lines(data), do: data |> String.split("\n", trim: true)

  def print_list([]), do: IO.puts("Empty")
  def print_list(list), do: Enum.each(list, fn x -> IO.puts(x) end)

  def string_list_to_integer_list(list), do: Enum.map(list, &String.to_integer/1)

  def search_for_2020_sum_2_numbers(list) do
    for x <- list, y <- list, x + y == 2020, do: [x, y]
  end

  def search_for_2020_sum_3_numbers(list) do
    for x <- list, y <- list, z <- list, x + y + z == 2020, do: [x, y, z]
  end

  def part1(pathname) do
    read_file(pathname)
    |> split_lines
    |> string_list_to_integer_list
    |> search_for_2020_sum_2_numbers
  end

  def part2(pathname) do
    read_file(pathname)
    |> split_lines
    |> string_list_to_integer_list
    |> search_for_2020_sum_3_numbers
  end
end
