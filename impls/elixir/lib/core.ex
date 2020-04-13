defmodule Core do

  def namespace do
    %{
      "+" => fn [x, y] -> x + y end,
      "-" => fn [x, y] -> x - y end,
      "*" => fn [x, y] -> x * y end,
      "/" => fn [x, y] -> div(x, y) end,
      "=" => fn [x, y] -> x == y end,
      "<" => fn [x, y] -> x < y end,
      ">" => fn [x, y] -> x > y end,
      "<=" => fn [x, y] -> x <= y end,
      ">=" => fn [x, y] -> x >= y end,
      "prn" => fn [x | _] -> x |> Printer.pr_str |> IO.puts; nil end,
      "list" => &Function.identity/1,
      "list?" => fn [x | _] -> is_list(x) end,
      "empty?" => fn [x | _] -> Enum.empty?(x) end,
      "count" => &count/1
    }
  end

  def count([x | _]) when is_list(x), do: Enum.count(x)
  def count(x), do: 0

end
