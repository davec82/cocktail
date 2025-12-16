defmodule Cocktail.Util do
  @moduledoc false

  def next_gte([], _), do: nil
  def next_gte([x | rest], search), do: if(x >= search, do: x, else: next_gte(rest, search))

  @doc """
  Normalizes microsecond to {0, 0} for DateTime and NaiveDateTime.
  This ensures consistent comparison across Elixir versions.
  In Elixir 1.15+, Timex operations may produce microseconds with precision {0, 6},
  while older versions produce {0, 0}. We normalize to {0, 0} for consistency.
  """
  def normalize_microsecond(%DateTime{} = dt), do: %{dt | microsecond: {0, 0}}
  def normalize_microsecond(%NaiveDateTime{} = ndt), do: %{ndt | microsecond: {0, 0}}
  def normalize_microsecond(other), do: other
end
