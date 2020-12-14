defmodule Aoc.Day13 do
  def part1(pathname) do
    {curr_time, buses} = pathname
    |> Aoc.Day1.read_file()
    |> Aoc.Day1.split_lines()
    |> clear_bus_input
    time_to = Enum.map(buses, &(rem(curr_time, &1)))
    time_left = Enum.map(0..length(time_to) - 1, fn x -> abs(Enum.at(time_to, x) - Enum.at(buses, x)) end)
    minimum = Enum.min(time_left)

    index = Enum.find_index(time_left, fn x -> x == minimum end)
    IO.inspect(buses)
    IO.inspect(time_left)
    IO.puts(index)
    Enum.at(buses, index) * minimum
  end

  def part2(pathname) do
    pathname
    |> Aoc.Day1.read_file
    |> Aoc.Day1.split_lines
    |> convert_buses
    |> run_till_sequence(0) 
  end

  defp run_till_sequence(list, timestamp) do
    first = List.first(list)
    IO.puts(timestamp)
    case is_sequence?(list, timestamp+first) do
      true -> timestamp+first
      false -> run_till_sequence(list, timestamp+first)
    end
  end

  # TODO Chinese remainder Theorem

  defp is_sequence?([], _), do: true
  defp is_sequence?([0 | t], timestamp), do: is_sequence?(t, timestamp+1)
  defp is_sequence?([h | t], timestamp) do
    case rem(timestamp, h) do
      0 -> is_sequence?(t, timestamp+1)
      _ -> false
    end
  end

  defp convert_buses([_, buses]) do
    Enum.map(String.split(buses, ","), fn x -> convert(x) end)
  end

  defp convert("x"), do: 0
  defp convert(x), do: String.to_integer(x)

  defp clear_bus_input([curr_time, buses]) do
    {
      String.to_integer(curr_time),
      Enum.map(Enum.filter(String.split(buses, ","), &(&1 != "x")), &(String.to_integer(&1)))
    }
  end
end
