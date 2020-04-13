defmodule Printer do

  def pr_str(%Ast{type: type, value: value}) do
    case type do
      :symbol -> value
      :atom -> Atom.to_string(value)
      :integer -> Integer.to_string(value)
      :list ->
        "(" <> (Enum.map(value, &pr_str/1) |> Enum.join(" ")) <> ")"
    end
  end

  def pr_str(value) when is_list(value) do
    "(" <> (Enum.map(value, &pr_str/1) |> Enum.join(" ")) <> ")"
  end

  def pr_str(value) when is_integer(value), do: Integer.to_string(value)
  def pr_str(value) when is_function(value), do: "#<function>"
  def pr_str(value), do: inspect(value)
end
