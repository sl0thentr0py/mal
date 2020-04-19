defmodule Mal do

  def read(line), do: Reader.read_str(line)

  def eval(%Ast{type: :list, value: []} = ast, env), do: ast

  def eval(%Ast{type: :list, value: value} = ast, env) do
    [%Ast{type: type, value: first} | tail] = value

    case {type, first} do
      {:symbol, "def!"} ->
        set_bindings(tail, env)
      {:symbol, "let*"} ->
        [%Ast{type: :list, value: bindings}, expr] = tail
        inner = Env.start_link(env)
        set_bindings(bindings, inner)
        eval(expr, inner)
      {:symbol, "do"} ->
        [last | rev] = Enum.reverse(tail)
        eval_ast(%Ast{type: :list, value: Enum.reverse(rev)}, env)
        eval(last, env)
      {:symbol, "if"} ->
        [condition, t_exp | f_exp] = tail
        case eval(condition, env) do
          v when v in [false, nil] ->
            case f_exp do
              [] -> nil
              [exp] -> eval(exp, env)
            end
          _ -> eval(t_exp, env)
        end
      {:symbol, "fn*"} ->
        [argc, body] = tail
        fn argv ->
          argc = Enum.map(argc.value, fn %Ast{type: :symbol, value: v} -> v end)
          stack = Env.start_link(env, argc, argv)
          eval(body, stack)
        end
      _ ->
        [fun | args] = eval_ast(ast, env)
        apply(fun, [args])
    end
  end

  def eval(ast, env), do: eval_ast(ast, env)

  def set_bindings([], _env), do: nil

  def set_bindings([%Ast{type: :symbol, value: key}, val | tail], env) do
    evald = eval(val, env)
    Env.set(env, key, evald)
    set_bindings(tail, env)
    evald
  end

  def eval_ast(ast, env) do
    %Ast{type: type, value: value} = ast

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
    env = Env.start_link
    Enum.each(Core.namespace, fn {k, v} -> Env.set(env, k, v) end)

    loop(env)
  end

end
