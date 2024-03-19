defmodule Cocktail.Validation do
  @moduledoc false

  alias Cocktail.Validation.{
    Day,
    DayOfMonth,
    HourOfDay,
    Interval,
    MinuteOfHour,
    MonthOfYear,
    MonthOfYearByDay,
    Nday,
    ScheduleLock,
    SecondOfMinute,
    TimeOfDay,
    TimeRange
  }

  @type validation_key ::
          :base_sec
          | :base_min
          | :base_hour
          | :base_wday
          | :base_mday
          | :base_yday
          | :day
          | :day_of_month
          | :hour_of_day
          | :month_of_year
          | :minute_of_hour
          | :nday
          | :second_of_minute
          | :time_of_day
          | :time_range
          | :interval

  @type validations_map :: %{validation_key => t}

  @type t ::
          ScheduleLock.t()
          | Interval.t()
          | Day.t()
          | DayOfMonth.t()
          | HourOfDay.t()
          | MonthOfYear.t()
          | MinuteOfHour.t()
          | Nday.t()
          | SecondOfMinute.t()
          | TimeOfDay.t()
          | TimeRange.t()

  @rule_days [:days, :days_of_month, :ndays, :day, :nday, :day_of_month]

  @spec build_validations(Cocktail.rule_options()) :: validations_map
  def build_validations(options) do
    {frequency, options} = Keyword.pop(options, :frequency)
    {interval, options} = Keyword.pop(options, :interval, 1)

    frequency
    |> build_basic_interval_validations(interval)
    |> apply_options(options)
  end

  @spec build_basic_interval_validations(Cocktail.frequency(), pos_integer) :: validations_map
  defp build_basic_interval_validations(:yearly, interval) do
    %{
      base_sec: ScheduleLock.new(:second),
      base_min: ScheduleLock.new(:minute),
      base_hour: ScheduleLock.new(:hour),
      base_yday: ScheduleLock.new(:yday),
      interval: Interval.new(:yearly, interval)
    }
  end

  defp build_basic_interval_validations(:monthly, interval) do
    %{
      base_sec: ScheduleLock.new(:second),
      base_min: ScheduleLock.new(:minute),
      base_hour: ScheduleLock.new(:hour),
      base_mday: ScheduleLock.new(:mday),
      interval: Interval.new(:monthly, interval)
    }
  end

  defp build_basic_interval_validations(:weekly, interval) do
    %{
      base_sec: ScheduleLock.new(:second),
      base_min: ScheduleLock.new(:minute),
      base_hour: ScheduleLock.new(:hour),
      base_wday: ScheduleLock.new(:wday),
      interval: Interval.new(:weekly, interval)
    }
  end

  defp build_basic_interval_validations(:daily, interval) do
    %{
      base_sec: ScheduleLock.new(:second),
      base_min: ScheduleLock.new(:minute),
      base_hour: ScheduleLock.new(:hour),
      interval: Interval.new(:daily, interval)
    }
  end

  defp build_basic_interval_validations(:hourly, interval) do
    %{
      base_sec: ScheduleLock.new(:second),
      base_min: ScheduleLock.new(:minute),
      interval: Interval.new(:hourly, interval)
    }
  end

  defp build_basic_interval_validations(:minutely, interval) do
    %{
      base_sec: ScheduleLock.new(:second),
      interval: Interval.new(:minutely, interval)
    }
  end

  defp build_basic_interval_validations(:secondly, interval) do
    %{
      interval: Interval.new(:secondly, interval)
    }
  end

  @spec apply_options(validations_map, Cocktail.rule_options()) :: validations_map
  defp apply_options(map, []), do: map

  defp apply_options(map, [{:months_of_year, months_of_year} | rest]) when length(months_of_year) > 0 do
    mod = get_module_month_year(map, rest)

    map
    |> Map.delete(:base_mday)
    |> Map.delete(:base_yday)
    |> Map.put(:month_of_year, mod.new(months_of_year))
    |> apply_options(rest)
  end

  defp apply_options(map, [{:days_of_month, days_of_month} | rest]) when length(days_of_month) > 0 do
    map
    |> Map.delete(:base_mday)
    |> Map.delete(:base_yday)
    |> Map.put(:day_of_month, DayOfMonth.new(days_of_month))
    |> apply_options(rest)
  end

  defp apply_options(map, [{:days, days} | rest]) when length(days) > 0 do
    map
    |> Map.delete(:base_wday)
    |> Map.delete(:base_mday)
    |> Map.delete(:base_yday)
    |> Map.put(:day, Day.new(days))
    |> apply_options(rest)
  end

  defp apply_options(map, [{:ndays, days} | rest]) when length(days) > 0 do
    offset = get_offset_nday(map, rest)

    map
    |> Map.delete(:base_wday)
    |> Map.delete(:base_mday)
    |> Map.delete(:base_yday)
    |> Map.put(:nday, Nday.new(days, offset))
    |> apply_options(rest)
  end

  defp apply_options(map, [{:hours, hours} | rest]) when length(hours) > 0 do
    map
    |> Map.delete(:base_hour)
    |> Map.put(:hour_of_day, HourOfDay.new(hours))
    |> apply_options(rest)
  end

  defp apply_options(map, [{:minutes, minutes} | rest]) when length(minutes) > 0 do
    map
    |> Map.delete(:base_min)
    |> Map.put(:minute_of_hour, MinuteOfHour.new(minutes))
    |> apply_options(rest)
  end

  defp apply_options(map, [{:seconds, seconds} | rest]) when length(seconds) > 0 do
    map
    |> Map.delete(:base_sec)
    |> Map.put(:second_of_minute, SecondOfMinute.new(seconds))
    |> apply_options(rest)
  end

  defp apply_options(map, [{:times, times} | rest]) when length(times) > 0 do
    map
    |> Map.delete(:base_sec)
    |> Map.delete(:base_min)
    |> Map.delete(:base_hour)
    |> Map.put(:time_of_day, TimeOfDay.new(times))
    |> apply_options(rest)
  end

  defp apply_options(map, [{:time_range, time_range} | rest]) do
    map
    |> Map.delete(:base_sec)
    |> Map.delete(:base_min)
    |> Map.delete(:base_hour)
    |> Map.put(:time_range, TimeRange.new(time_range))
    |> apply_options(rest)
  end

  # unhandled option, just discard and continue
  defp apply_options(map, [{_, _} | rest]), do: map |> apply_options(rest)

  defp get_module_month_year(map, options) do
    case @rule_days |> Enum.any?(&Map.has_key?(map, &1)) or
           Enum.any?(@rule_days, fn k -> k in Keyword.keys(options) end) do
      true -> MonthOfYearByDay
      _ -> MonthOfYear
    end
  end

  defp get_offset_nday(map, options) do
    %{interval: interval} = map
    key_months = [:months_of_year]

    case key_months |> Enum.any?(&Map.has_key?(map, &1)) or
           Enum.any?(key_months, fn k -> k in Keyword.keys(options) end) do
      true -> :monthly
      _ -> interval.type
    end
  end
end
