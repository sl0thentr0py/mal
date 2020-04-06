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
        [%AstNode{type: :symbol, value: first} | tail] = value
        case first do
          "def!" ->
            set_bindings(tail, env)
          "let*" ->
            [%AstNode{type: :list, value: bindings}, expr] = tail
            {:ok, inner} = Env.start_link(env)
            set_bindings(bindings, inner)
            eval(expr, inner)
          _ ->
            [fun | args] = eval_ast(ast, env)
            apply(fun, args)
        end
    end
  end

  def eval(ast, env), do: eval_ast(ast, env)

  def set_bindings([], _env), do: nil

  def set_bindings([%AstNode{type: :symbol, value: key}, val | tail], env) do
    evald = eval(val, env)
    Env.set(env, key, evald)
    set_bindings(tail, env)
    evald
  end

  def eval_ast(ast, env) do
    %AstNode{type: type, value: value} = ast

    case type do
      :symbol ->
        case Env.get(env, value) do
          {:ok, val} -> val
          :error -> throw({:error, "#{value} not found"})
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

  def loop(env) do
    IO.gets("user> ")
    |> rep(env)
    |> IO.puts

    loop(env)
  end

  def main do
    {:ok, env} = Env.start_link
    Enum.each(@repl_env, fn {k, v} -> Env.set(env, k, v) end)

    loop(env)
  end

end
