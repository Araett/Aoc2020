defmodule Aoc.Day9 do
  def read_file(pathname) do
    {:ok, contents} = File.read(pathname)
    contents
  end

  def split_lines(data), do: data |> String.split("\n", trim: true)

  def permutations([], _), do: [[]]
  def permutations(_, 0), do: [[]]

  def permutations(list, n),
    do: for(h <- list, t <- permutations(list -- [h], n - 1), do: [h | t])

  def part1(pathname, preamble) do
    pathname
    |> read_file
    |> split_lines
    |> Enum.map(&String.to_integer(&1))
    |> check_cypher(preamble, preamble)
  end

  def part2(pathname, preamble) do
    list =
      pathname
      |> read_file
      |> split_lines
      |> Enum.map(&String.to_integer(&1))

    number = check_cypher(list, preamble, preamble)

    2..length(list)
    |> Stream.map(fn x -> Stream.chunk_every(list, x, 1, :discard) end)
    # |> Enum.map(fn x -> Enum.to_list(x) end)
    |> Enum.find(fn x -> number in Enum.map(x, &Enum.sum(&1)) end)
    |> Enum.find(fn x -> number == Enum.sum(x) end)
    |> answer
  end

  defp answer(list), do: Enum.min(list) + Enum.max(list)

  defp check_cypher(list, _, index) when length(list) <= index, do: :eol

  defp check_cypher(list, preamble, index) do
    perm =
      (index - preamble)..(index - 1)
      |> Enum.map(&Enum.at(list, &1))
      |> permutations(2)
      |> Enum.map(&Enum.sum(&1))

    case Enum.at(list, index) in perm do
      false -> Enum.at(list, index)
      true -> check_cypher(list, preamble, index + 1)
    end
  end
end
