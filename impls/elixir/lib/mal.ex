defmodule Mal do

  @repl_env %{
    "+" => &+/2,
    "-" => &-/2,
    "*" => &*/2,
    "/" => &div/2
  }

  def read(line), do: Reader.read_str(line)

  def eval(%AstNode{type: :list, value: value} = ast, env) do
    case value do
      [] -> ast
      _ ->
        [fun | args] = eval_ast(ast, env)
        apply(fun, args)
    end
  end

  def eval(ast, env), do: eval_ast(ast, env)

  def eval_ast(ast, env) do
    %AstNode{type: type, value: value} = ast

    case type do
      :symbol ->
        case Map.fetch(env, value) do
          {:ok, val} -> val
          :error -> throw({:error, "Undefined symbol"})
        end
      :list -> Enum.map(value, fn x -> eval(x, env) end)
      _ -> value
    end
  end

  def print(out), do: Printer.pr_str(out)

  def rep(:eof, _env), do: exit(:normal)
  def rep(line, env) do
    line |> String.trim |> read |> eval(env) |> print
  catch
    {:error, message} -> IO.puts("Error: #{message}")
  end

  def main do
    IO.gets("user> ")
    |> rep(@repl_env)
    |> IO.puts

    main
  end

end
