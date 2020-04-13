defmodule Reader do
  import Types

  def read_str(str) do
    str |> tokenize |> read_form |> elem(0)
  end

  def tokenize(str) do
    regex = ~r/[\s,]*(~@|[\[\]{}()'`~^@]|"(?:\\.|[^\\"])*"?|;.*|[^\s\[\]{}('"`,;)]*)/

    Regex.scan(regex, str, capture: :all_but_first)
    |> List.flatten
    |> List.delete_at(-1)
  end

  def read_form(["(" | tokens]) do
    {list, rest} = read_list(tokens, [])
    {%AstNode{type: :list, value: list}, rest}
  end

  def read_form([atom | rest]), do: { read_atom(atom), rest }

  def read_list([], _), do: throw({:error, "Unexpected end of input"})
  def read_list([")" | rest], acc), do: {Enum.reverse(acc), rest}
  def read_list(tokens, acc) do
    {parsed, rest} = read_form(tokens)
    read_list(rest, [parsed | acc])
  end

  def read_atom(":" <> rest) do
    %AstNode{ type: :atom, value: String.to_atom(rest) }
  end

  def read_atom("nil") do
    %AstNode{ type: :nil, value: nil }
  end

  def read_atom("true") do
    %AstNode{ type: :boolean, value: true }
  end

  def read_atom("false") do
    %AstNode{ type: :boolean, value: false }
  end

  def read_atom(token) do
    cond do
      integer?(token) ->
        %AstNode{ type: :integer, value: Integer.parse(token) |> elem(0) }
      true ->
        %AstNode{ type: :symbol, value: token }
    end
  end

end
