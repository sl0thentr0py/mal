defmodule Mal do

  def read(line), do: Reader.read_str(line)
  def eval(ast), do: ast
  def print(ast), do: Printer.pr_str(ast)

  def rep(:eof), do: exit(:normal)
  def rep(line) do
    line |> String.trim |> read |> eval |> print
  catch
    {:error, message} -> IO.puts("Error: #{message}")
  end

  def main do
    IO.gets("user> ")
    |> rep
    |> IO.puts

    main
  end

end
