defmodule Aoc.Day8 do
  def read_file(pathname) do
    {:ok, contents} = File.read(pathname)
    contents
  end

  def split_lines(data), do: data |> String.split("\n", trim: true)

  def part1(pathname) do
    pathname
    |> read_file
    |> split_lines
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(&List.to_tuple(&1))
    |> run_program(0, 0, [])
  end

  def part2(pathname) do
    code =
      pathname
      |> read_file
      |> split_lines
      |> Enum.map(&String.split(&1, " ", trim: true))
      |> Enum.map(&List.to_tuple(&1))

    0..(length(code) - 1)
    |> Enum.filter(fn x -> is_nop_or_jmp?(Enum.at(code, x)) end)
    |> Enum.map(fn x -> fix_and_run_corrupt_program(x, code) end)
    |> Enum.filter(fn x -> x != :loop end)
  end

  defp flip_command({command, value}) do
    case command do
      "nop" -> {"jmp", value}
      "jmp" -> {"nop", value}
    end
  end

  defp construct_new_code(index, code) do
    {part1, part2} = Enum.split(code, index)
    {command, part2} = Enum.split(part2, 1)

    (part1 ++ [flip_command(List.first(command))])
    |> Kernel.++(part2)
  end

  defp fix_and_run_corrupt_program(index, code) do
    construct_new_code(index, code)
    |> run_program(0, 0, [])
  end

  defp is_nop_or_jmp?({command, _}), do: command == "nop" or command == "jmp"

  defp run_program(code, acc, index, _) when length(code) <= index, do: acc

  defp run_program(code, acc, index, history) do
    if index in history do
      :loop
    else
      {command, value} = Enum.at(code, index)

      case command do
        "nop" -> run_program(code, acc, index + 1, [index | history])
        "acc" -> run_program(code, acc + String.to_integer(value), index + 1, [index | history])
        "jmp" -> run_program(code, acc, index + String.to_integer(value), [index | history])
      end
    end
  end
end
