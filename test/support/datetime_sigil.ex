defmodule Cocktail.TestSupport.DateTimeSigil do
  @moduledoc """
  Test helper sigil for defining DateTimes with zones
  """

  def sigil_Y(string, []) do
    [date, time, zone] = String.split(string, " ")

    "#{date} #{time}"
    |> NaiveDateTime.from_iso8601!()
    |> Timex.to_datetime(zone)
    |> Map.put(:microsecond, {0, 0})
  end
end
