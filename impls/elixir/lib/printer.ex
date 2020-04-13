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

  def pr_str(value, _readable \\ false), do: inspect(value)
end
