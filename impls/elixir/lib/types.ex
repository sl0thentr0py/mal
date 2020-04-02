defmodule Types do
  def integer?(token) do
    Regex.match?(~r/^-?\d+$/, token)
  end
end
