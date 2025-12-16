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

  def beginning_of_day(time) do
    time
    |> Timex.beginning_of_day()
    |> no_ms()
  end

  def beginning_of_month(time) do
    time
    |> Timex.beginning_of_month()
    |> no_ms()
  end

  def shift_time(datetime, opts) do
    datetime
    |> Timex.shift(opts)
    |> shift_dst(datetime)
    |> no_ms()
  end

  def no_ms(time) do
    Map.put(time, :microsecond, {0, 0})
  end

  # In case of datetime we may expect the same timezone hour
  # For example after daylight saving 10h MUST still 10h the next day.
  # This behaviour could only happen on datetime with timezone (that include `std_offset`)
  defp shift_dst(time, datetime) do
    if offset = Map.get(datetime, :std_offset) do
      shifted = Timex.shift(time, seconds: offset - time.std_offset)
      # Fix for DST gap: if shifting to compensate for DST causes time to go backwards
      # (e.g., when the shifted time falls into a DST gap and gets pushed back),
      # keep the original time to avoid infinite loops
      case DateTime.compare(shifted, datetime) do
        :gt -> shifted
        _ -> time
      end
    else
      time
    end
  end
end
