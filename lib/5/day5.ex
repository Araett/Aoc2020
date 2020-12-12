defmodule Aoc.Day5 do
  def read_file(pathname) do
    {:ok, contents} = File.read(pathname)
    contents
  end

  def split_lines(data), do: data |> String.split("\n", trim: true)

  def part1(pathname) do
    pathname
    |> read_file
    |> split_lines
    |> Enum.map(&find_id(&1))
    |> Enum.max()
  end

  def part2(pathname) do
    pathname
    |> read_file
    |> split_lines
    |> Enum.map(&find_id(&1))
    |> find_missing_seat
  end

  defp find_missing_seat(id_list) do
    all_seats = Enum.to_list(Enum.min(id_list)..Enum.max(id_list)) |> MapSet.new()
    current_seats = MapSet.new(id_list)
    MapSet.difference(all_seats, current_seats)
  end

  defp find_id(data) do
    row = String.graphemes(data) |> Enum.take(7) |> find_row(0..127)
    column = String.graphemes(data) |> Enum.take(-3) |> find_column(0..7)
    row * 8 + column
  end

  defp find_row([], same..same), do: same

  defp find_row([head | tail], min..max) do
    case head do
      "F" -> find_row(tail, min..(max - div(Enum.count(min..max), 2)))
      "B" -> find_row(tail, (min + div(Enum.count(min..max), 2))..max)
    end
  end

  defp find_column([], same..same), do: same

  defp find_column([head | tail], min..max) do
    case head do
      "L" -> find_column(tail, min..(max - div(Enum.count(min..max), 2)))
      "R" -> find_column(tail, (min + div(Enum.count(min..max), 2))..max)
    end
  end
end
