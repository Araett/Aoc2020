defmodule Aoc.Day2 do
  def read_file(pathname) do
    {:ok, contents} = File.read(pathname)
    contents
  end

  def split_lines(data), do: data |> String.split("\n", trim: true)

  def part1(pathname) do
    pathname
    |> read_file
    |> split_lines
    |> Enum.map(fn x -> parse_pass_data(x) |> is_valid1 end)
    |> Enum.sum()
  end

  def part2(pathname) do
    pathname
    |> read_file
    |> split_lines
    |> Enum.map(fn x -> parse_pass_data(x) |> is_valid2 end)
    |> Enum.sum()
  end

  defp parse_pass_data(pass_data) do
    pass_data
    |> String.split(["-", " ", ":"], trim: true)
    |> List.to_tuple()
  end

  defp is_in_range(n, min, max) when n in min..max, do: 1
  defp is_in_range(_, _, _), do: 0

  defp is_valid1({min, max, letter, password}) do
    password
    |> String.graphemes()
    |> Enum.count(fn x -> x == letter end)
    |> is_in_range(String.to_integer(min), String.to_integer(max))
  end

  defp is_valid2({pos1, pos2, letter, password}) do
    [
      String.at(password, String.to_integer(pos1) - 1),
      String.at(password, String.to_integer(pos2) - 1)
    ]
    |> Enum.count(fn x -> x == letter end)
    |> rem(2)
  end
end
