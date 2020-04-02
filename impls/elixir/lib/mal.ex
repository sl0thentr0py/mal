defmodule Mal do

  def read(line), do: line
  def eval(line), do: line
  def print(line), do: line

  def rep(:eof), do: exit(:normal)
  def rep(line) do
    line |> read |> eval |> print
  end

  def main do
    IO.gets("user> ")
    |> rep
    |> IO.puts

    main
  end

end
