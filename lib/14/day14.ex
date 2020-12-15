defmodule Aoc.Day14 do

  def part1(pathname) do
    pathname
    |> Aoc.Day1.read_file
    |> split_data
    |> Enum.map(fn x -> Aoc.Day1.split_lines(x) end)
    |> Enum.map(fn x -> convert_to_memory(x) end)
    |> Enum.reduce(%{}, fn (elem, acc) -> Map.merge(acc, elem) end)
    |> Map.values
    |> Enum.sum
  end

  defp split_data(data), do: String.split(data, "mask = ", trim: true)

  defp convert_to_memory([mask | mem_blocks]) do
    mask_and_populate_memory(String.graphemes(mask), mem_blocks, [])
    |> Map.new
  end

  defp mask_and_populate_memory(_, [], acc), do: acc
  defp mask_and_populate_memory(mask, [h | t], acc) do
    {id, value} = parse_memory(h)
    mask_and_populate_memory(mask, t, [{id, mask_value(mask, value)} | acc])
  end

  defp mask_value(mask, value) do
    Integer.to_string(value, 2)
    |> String.graphemes
    |> add_padding(length(mask))
    |> mask(mask, [])
    |> Enum.join
    |> String.to_integer(2)
  end

  defp mask([], [], acc), do: acc
  defp mask([value | vt], ["X" | mt], acc) do
    mask(vt, mt, acc ++ [value])
  end

  defp mask([_ | vt], [mask | mt], acc) do
    mask(vt, mt, acc ++ [mask])
  end

  defp add_padding(value, len) when length(value) == len, do: value
  defp add_padding(value, len), do: add_padding(["0" | value], len)

  defp parse_memory(mem) do
    [mem_address, value] = String.split(mem, " = ", trim: true)
    [_, address] = String.split(mem_address, ["[", "]"], trim: true)
    {String.to_integer(address), String.to_integer(value)}
  end

end
