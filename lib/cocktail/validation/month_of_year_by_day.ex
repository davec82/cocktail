defmodule Cocktail.Validation.MonthOfYearByDay do
  @moduledoc false

  import Cocktail.Validation.Shift

  @type t :: %__MODULE__{months: [Cocktail.month_of_year()]}

  @enforce_keys [:months]
  defstruct months: []

  @spec new([Cocktail.month_of_year()]) :: t
  def new(months), do: %__MODULE__{months: months}

  @spec next_time(t, Cocktail.time(), Cocktail.time()) :: Cocktail.Validation.Shift.result()
  def next_time(%__MODULE__{months: months}, time, start_time) do
    normalized_months =
      months
      |> Enum.sort()

    days_diff =
      case time.month in normalized_months do
        true ->
          0

        _ ->
          new_time = find_next_month_day(time, start_time, normalized_months)
          Timex.diff(new_time, time, :days)
      end

    shift_by(days_diff, :days, time, :beginning_of_day)
  end

  defp find_next_month_day(time, start_time, normalized_months) do
    start_day = start_time.day

    case start_day <= Timex.days_in_month(time) do
      true ->
        maybe_shift_month(time, start_time, normalized_months)

      false ->
        find_next_month_day(shift_to_first_month_day(time), start_time, normalized_months)
    end
  end

  defp maybe_shift_month(time, start_time, normalized_months) do
    case time.month in normalized_months do
      true -> time
      _ -> find_next_month_day(shift_to_first_month_day(time), start_time, normalized_months)
    end
  end

  defp shift_to_first_month_day(time) do
    time
    |> Timex.shift(months: 1)
    |> Timex.set(day: 1)
  end
end
