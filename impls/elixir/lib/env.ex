defmodule Env do
  use Agent

  def start_link(outer \\ nil) do
    Agent.start_link(fn -> %{outer: outer, env: %{}} end)
  end

  def set(agent, key, val) do
    Agent.update(agent, fn m ->
      %{m | env: Map.put(m.env, key, val)}
    end)
  end

  def find(agent, key) do
    Agent.get(agent, fn m ->
      case Map.has_key?(m.env, key) do
        true -> m.env
        false -> m.outer && find(m.outer, key)
      end
    end)
  end

  def get(agent, key) do
    case find(agent, key) do
      nil -> :error
      env -> Map.fetch(env, key)
    end
  end

  def stop(agent), do: Agent.stop(agent)
end
