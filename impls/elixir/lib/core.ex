defmodule Core do

  def namespace do
    %{
      "+" => fn [x, y] -> x + y end,
      "-" => fn [x, y] -> x - y end,
      "*" => fn [x, y] -> x * y end,
      "/" => fn [x, y] -> div(x, y) end,
      "prn" => &prn/1
        # "list" => &list/1
    }
  end

  defp prn(args) do
    args |> Printer.pr_str(true) |> IO.puts
    nil
  end

end
