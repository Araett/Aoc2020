defmodule Aoc.Day7 do
  def read_file(pathname) do
    {:ok, contents} = File.read(pathname)
    contents
  end

  def split_lines(data), do: data |> String.split("\n", trim: true)

  def part1(pathname) do
    pathname
    |> read_file
    |> split_lines
    |> build_directed_graph
    |> find_trees_with_target("shiny gold")
  end

  def part2(pathname) do
    pathname
    |> read_file
    |> split_lines
    |> build_directed_graph
    |> reduce_until_end(%{"shiny gold" => 1}, 0)
  end

  defp reduce_until_end(_, tree, acc) when map_size(tree) == 1 and is_map_key(tree, nil) do
    {tree, acc}
  end

  defp reduce_until_end(graph_map, tree, acc) do
    new_tree = breadth_search_nodes(graph_map, tree)
    reduce_until_end(graph_map, new_tree, acc + bag_count(new_tree))
  end

  defp bag_count(tree) do
    Map.keys(tree)
    |> Enum.filter(&(&1 != nil))
    |> Enum.reduce(0, fn elem, acc -> acc + tree[elem] end)
  end

  defp get_children(nil, multiplier, _), do: %{nil => multiplier}

  defp get_children(key, multiplier, graph_map) do
    graph_map[key]
    |> Map.to_list()
    |> Enum.map(fn x -> {elem(x, 0), elem(x, 1) * multiplier} end)
    |> Map.new()
  end

  defp sum_map_values(map1, map2) do
    Map.merge(map1, map2, fn _k, v1, v2 -> v1 + v2 end)
  end

  defp breadth_search_nodes(graph_map, tree) do
    Map.keys(tree)
    |> Enum.map(fn x -> get_children(x, tree[x], graph_map) end)
    |> Enum.reduce(%{}, fn elem, acc -> sum_map_values(elem, acc) end)
  end

  defp is_target_in_tree?(tree, target, _) when is_map_key(tree, target), do: true

  defp is_target_in_tree?(tree, _, _) when map_size(tree) == 1 and is_map_key(tree, nil),
    do: false

  defp is_target_in_tree?(tree, target, graph_map) do
    breadth_search_nodes(graph_map, tree)
    |> is_target_in_tree?(target, graph_map)
  end

  defp find_trees_with_target(graph_map, target) do
    Map.keys(graph_map)
    |> Enum.map(&(Map.new([{&1, 1}]) |> is_target_in_tree?(target, graph_map)))
    |> Enum.count(& &1)
    |> Kernel.-(1)
  end

  defp parse_child_node(child) do
    [count_string, color_string] = String.split(child, " ", parts: 2)
    color = String.split(color_string, [" bag", " bags"], trim: true) |> List.first()

    case count_string do
      "no" -> {nil, 1}
      _ -> {color, String.to_integer(count_string)}
    end
  end

  defp parse_line(line) do
    [node, children_string] = String.split(line, " bags contain ", trim: true)

    children =
      String.split(children_string, [", ", "."], trim: true)
      |> Enum.map(&parse_child_node(&1))
      |> Enum.filter(&(&1 != nil))
      |> Map.new()

    {node, children}
  end

  defp build_directed_graph(lines) do
    lines
    |> Enum.map(&parse_line(&1))
    |> Map.new()
  end
end
