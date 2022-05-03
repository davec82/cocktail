defmodule Cocktail.Validation.ScheduleLock do
  @moduledoc false

  import Integer, only: [mod: 2]
  import Cocktail.Validation.Shift

  @type lock :: :second | :minute | :hour | :wday | :mday | :yday

  @type t :: %__MODULE__{type: lock}

  @enforce_keys [:type]
  defstruct type: nil

  @spec new(lock) :: t
  def new(type), do: %__MODULE__{type: type}

  @spec next_time(t, Cocktail.time(), Cocktail.time()) :: Cocktail.Validation.Shift.result()
  def next_time(%__MODULE__{type: :second}, time, start_time),
    do: shift_by(mod(start_time.second - time.second, 60), :seconds, time)

  def next_time(%__MODULE__{type: :minute}, time, start_time),
    do: shift_by(mod(start_time.minute - time.minute, 60), :minutes, time)

  def next_time(%__MODULE__{type: :hour}, time, start_time),
    do: shift_by(mod(start_time.hour - time.hour, 24), :hours, time)

  def next_time(%__MODULE__{type: :wday}, time, start_time) do
    start_time_day = Timex.weekday(start_time)
    time_day = Timex.weekday(time)
    diff = mod(start_time_day - time_day, 7)

    shift_by(diff, :days, time)
  end

  def next_time(%__MODULE__{type: :mday}, time, start_time) do
    if start_time.day > Calendar.ISO.days_in_month(time.year, time.month) do
      next_time(%__MODULE__{type: :mday}, Timex.shift(time, months: 1), start_time)
    else
      next_mday_time(%__MODULE__{type: :mday}, time, start_time)
    end
  end

  def next_time(%__MODULE__{type: :yday}, time, start_time) do
    if start_time.day > Calendar.ISO.days_in_month(time.year, time.month) do
      next_time(%__MODULE__{type: :yday}, Timex.shift(time, months: 1), start_time)
    else
      maybe_is_leap_year(%__MODULE__{type: :yday}, time, start_time)
    end
  end

  defp next_yday_time(%__MODULE__{type: :yday}, time, start_time) do
    time_day_of_month = time.day

    day_diff =
      case start_time.day do
        ^time_day_of_month ->
          0

        _start_time_day_of_month ->
          next_year_date = maybe_last_year_day(time, start_time)
          fixed_day = maybe_fix_leap_day(next_year_date, start_time)

          next_year_date
          |> Timex.set(day: fixed_day, month: start_time.month)
          |> Timex.diff(time, :days)
      end

    shift_by(day_diff, :days, time)
  end

  defp next_mday_time(%__MODULE__{type: :mday}, time, start_time) do
    time_day_of_month = time.day

    day_diff =
      case start_time.day do
        # no day shift when there is day of month difference
        ^time_day_of_month ->
          0

        # We to the same day of month of start_time in next month if the days of month are not equal
        start_time_day_of_month when start_time_day_of_month > time_day_of_month ->
          time
          |> Timex.set(day: start_time_day_of_month)
          |> Timex.diff(time, :days)

        start_time_day_of_month ->
          next_month_date = Timex.shift(time, months: 1)
          # Timex.set already handle the marginal case like setting a day of month more than the month contains
          next_month_date
          |> Timex.set(day: start_time_day_of_month)
          |> Timex.diff(time, :days)
      end

    shift_by(day_diff, :days, time)
  end

  defp maybe_is_leap_year(%__MODULE__{type: :yday}, time, start_time) when time.day == start_time.day do
    shift_by(0, :days, time)
  end

  defp maybe_is_leap_year(%__MODULE__{type: :yday}, time, start_time) do
    maybe_is_start_month(time, start_time)
  end

  defp maybe_is_start_month(time, start_time) do
    diff_days = start_time.day - time.day

    if diff_days >= 1 and start_time.month == time.month do
      new_new_time = Timex.set(time, day: start_time.day, month: start_time.month)

      shift_by(0, :days, new_new_time)
    else
      next_yday_time(%__MODULE__{type: :yday}, time, start_time)
    end
  end

  defp maybe_fix_leap_day(time, start_time) do
    case Timex.is_leap?(start_time.year) and start_time.day > Calendar.ISO.days_in_month(time.year, 2) do
      true -> start_time.day - 1
      _ -> start_time.day
    end
  end

  defp maybe_last_year_day(time, start_time) when start_time.day == 31 and start_time.month == 12 do
    time
  end

  defp maybe_last_year_day(time, _start_time) do
    Timex.shift(time, years: 1)
  end
end
