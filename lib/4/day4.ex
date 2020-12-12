defmodule Aoc.Day4 do
  def read_file(pathname) do
    {:ok, contents} = File.read(pathname)
    contents
  end

  def split_data(data), do: data |> String.split("\n\n", trim: true)

  def split_passport_info(data), do: data |> String.split([" ", "\n"], trim: true)

  def part1(pathname) do
    control_keys = MapSet.new(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid", "cid"])

    pathname
    |> read_file
    |> split_data
    |> Enum.map(fn x -> split_passport_info(x) end)
    |> Enum.map(fn x -> convert_to_map(x) end)
    |> Enum.map(fn x -> Map.keys(x) |> MapSet.new() |> get_control_keys_diff(control_keys) end)
    |> Enum.count(fn x -> x == MapSet.new(["cid"]) or MapSet.size(x) == 0 end)
  end

  def part2(pathname) do
    pathname
    |> read_file
    |> split_data
    |> Enum.map(fn x -> split_passport_info(x) end)
    |> Enum.map(fn x -> convert_to_map(x) end)
    |> Enum.map(fn x -> check_fields_validity(x) end)
    |> Enum.map(fn x -> is_valid?(x) end)
    |> Enum.count(fn x -> x end)
  end

  defp check_fields_validity(passport) do
    [
      is_byr_good?(passport["byr"]),
      is_iyr_good?(passport["iyr"]),
      is_eyr_good?(passport["eyr"]),
      is_hgt_good?(passport["hgt"]),
      is_hcl_good?(passport["hcl"]),
      is_ecl_good?(passport["ecl"]),
      is_pid_good?(passport["pid"]),
      is_cid_good?(passport["cid"])
    ]
  end

  defp is_byr_good?(value) when is_binary(value), do: String.to_integer(value) in 1920..2002
  defp is_byr_good?(_), do: false

  defp is_iyr_good?(value) when is_binary(value), do: String.to_integer(value) in 2010..2020
  defp is_iyr_good?(_), do: false

  defp is_eyr_good?(value) when is_binary(value), do: String.to_integer(value) in 2020..2030
  defp is_eyr_good?(_), do: false

  defp is_hgt_good?(value) when is_binary(value) do
    cond do
      String.ends_with?(value, "cm") -> String.to_integer(String.slice(value, 0..-3)) in 150..193
      String.ends_with?(value, "in") -> String.to_integer(String.slice(value, 0..-3)) in 59..76
      true -> false
    end
  end

  defp is_hgt_good?(_), do: false

  defp is_hcl_good?(value) when is_binary(value) do
    String.starts_with?(value, "#") and
      :error not in (String.slice(value, 1..-1)
                     |> String.graphemes()
                     |> Enum.map(&Integer.parse(&1, 16)))
  end

  defp is_hcl_good?(_), do: false

  defp is_ecl_good?(value) when is_binary(value),
    do: value in ["amb", "blu", "brn", "gry", "grn", "grn", "hzl", "oth"]

  defp is_ecl_good?(_), do: false

  defp is_pid_good?(value) when is_binary(value) do
    String.length(value) == 9 and Integer.parse(value) != :error
  end

  defp is_pid_good?(_), do: false

  defp is_cid_good?(_), do: true

  defp is_valid?(passport_checks), do: false not in passport_checks

  defp convert_string_to_keyvalue_tuple(string), do: List.to_tuple(String.split(string, ":"))

  defp convert_to_map(data_list) do
    data_list
    |> Enum.map(fn x -> convert_string_to_keyvalue_tuple(x) end)
    |> Map.new()
  end

  defp get_control_keys_diff(keys, control_keys), do: MapSet.difference(control_keys, keys)
end
