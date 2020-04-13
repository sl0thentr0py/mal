defmodule Core do

  def namespace do
    %{
      "+" => fn [x, y] -> x + y end,
      "-" => fn [x, y] -> x - y end,
      "*" => fn [x, y] -> x * y end,
      "/" => fn [x, y] -> div(x, y) end
    }
  end

end
