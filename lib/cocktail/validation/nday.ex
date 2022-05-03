defmodule Cocktail.Validation.Nday do
  @moduledoc false

  import Cocktail.Validation.Shift

  import Integer, only: [mod: 2]

  @type frequency :: :yearly | :monthly
  @type t :: %__MODULE__{days: [{integer, Cocktail.day_number()}], offset: frequency}

  @enforce_keys [:days, :offset]
  defstruct days: [],
            offset: :monthly

  @spec new([Cocktail.nday()], Cocktail.frequency()) :: t
  def new(days, interval), do: %__MODULE__{days: days |> Enum.map(&day_number/1), offset: interval}

  @spec next_time(t, Cocktail.time(), Cocktail.time()) :: Cocktail.Validation.Shift.result()
  def next_time(%__MODULE__{days: days, offset: freq}, time, _) do
    {first_month_date, last_month_date} = choose_first_last_dates(freq, time)

    res = loop_days(time, days, first_month_date, last_month_date, freq)
    new_day = Enum.sort(res, {:asc, Date}) |> List.first(res)

    diff_days = Timex.diff(new_day, time, :days)

    shift_by(diff_days, :days, time, :beginning_of_day)
  end

  @spec day_number(Cocktail.nday()) :: {integer, Cocktail.day_number()}
  defp day_number({n, :sunday}), do: {n, 0}
  defp day_number({n, :monday}), do: {n, 1}
  defp day_number({n, :tuesday}), do: {n, 2}
  defp day_number({n, :wednesday}), do: {n, 3}
  defp day_number({n, :thursday}), do: {n, 4}
  defp day_number({n, :friday}), do: {n, 5}
  defp day_number({n, :saturday}), do: {n, 6}
  defp day_number({n, day}) when is_integer(day), do: {n, day}

  defp loop_days(time, days, first_month_date, last_month_date, freq) do
    last_month_day = last_month_date.day

    Enum.map(days, fn {n, wday} ->
      lookup_day(n, time, wday, first_month_date, last_month_date, last_month_day, freq)
    end)
  end

  defp lookup_day(n, time, wday, first_month_date, last_month_date, last_month_day, :monthly = freq) do
    nday = find_nth_day(n, wday, first_month_date, last_month_date, last_month_date.day)

    case nday >= time.day and nday <= last_month_day do
      true ->
        Timex.set(time, day: nday)

      false ->
        {next_time, next_first_month_date, next_last_month_date} = next_date(freq, time)

        lookup_day(n, next_time, wday, next_first_month_date, next_last_month_date, next_last_month_date.day, freq)
    end
  end

  defp lookup_day(n, time, wday, first_month_date, last_month_date, _last_month_day, :yearly = freq) do
    days_diff = Timex.diff(last_month_date, first_month_date, :days) + 1
    nday = find_nth_day(n, wday, first_month_date, last_month_date, days_diff)

    day_of_year = Calendar.ISO.day_of_year(time.year, time.month, time.day)

    case nday >= day_of_year and nday <= days_diff do
      true ->
        Timex.shift(Timex.beginning_of_year(time), days: nday)

      false ->
        {next_time, next_first_month_date, next_last_month_date} = next_date(freq, time)

        lookup_day(n, next_time, wday, next_first_month_date, next_last_month_date, next_last_month_date.day, freq)
    end
  end

  defp find_nth_day(n, wday, _first_day, last_day, last_index) when n < 0 do
    last_wday = Timex.weekday(last_day)
    last_index + (n + 1) * 7 - mod(last_wday - wday, 7)
  end

  defp find_nth_day(n, wday, first_day, _last_day, _last_index) do
    first_wday = Timex.weekday(first_day)
    first_day.day + (n - 1) * 7 + mod(7 - first_wday + wday, 7)
  end

  defp next_date(freq, time) do
    next_time = Timex.shift(time, months: 1) |> Timex.set(day: 1)
    {first_date, last_date} = choose_first_last_dates(freq, next_time)
    {next_time, first_date, last_date}
  end

  defp choose_first_last_dates(:monthly, time) do
    {Timex.beginning_of_month(time), Timex.end_of_month(time)}
  end

  defp choose_first_last_dates(:yearly, time) do
    {Timex.beginning_of_year(time), Timex.end_of_year(time)}
  end
end
