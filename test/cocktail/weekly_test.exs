defmodule Cocktail.WeeklyTest do
  use ExUnit.Case

  alias Cocktail.Schedule

  import Cocktail.TestSupport.DateTimeSigil

  test "Weekly" do
    times =
      ~Y[2017-01-01 06:00:00 America/Los_Angeles]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:weekly)
      |> Cocktail.Schedule.occurrences()
      |> Enum.take(3)

    assert times == [
             ~Y[2017-01-01 06:00:00 America/Los_Angeles],
             ~Y[2017-01-08 06:00:00 America/Los_Angeles],
             ~Y[2017-01-15 06:00:00 America/Los_Angeles]
           ]
  end

  test "Every 2 weeks" do
    times =
      ~Y[2017-01-01 06:00:00 America/Los_Angeles]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:weekly, interval: 2)
      |> Cocktail.Schedule.occurrences()
      |> Enum.take(3)

    assert times == [
             ~Y[2017-01-01 06:00:00 America/Los_Angeles],
             ~Y[2017-01-15 06:00:00 America/Los_Angeles],
             ~Y[2017-01-29 06:00:00 America/Los_Angeles]
           ]
  end

  test "Every 2 weeks / Every 3 weeks" do
    times =
      ~Y[2017-01-01 06:00:00 America/Los_Angeles]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:weekly, interval: 2)
      |> Schedule.add_recurrence_rule(:weekly, interval: 3)
      |> Cocktail.Schedule.occurrences()
      |> Enum.take(7)

    assert times == [
             ~Y[2017-01-01 06:00:00 America/Los_Angeles],
             ~Y[2017-01-15 06:00:00 America/Los_Angeles],
             ~Y[2017-01-22 06:00:00 America/Los_Angeles],
             ~Y[2017-01-29 06:00:00 America/Los_Angeles],
             ~Y[2017-02-12 06:00:00 America/Los_Angeles],
             ~Y[2017-02-26 06:00:00 America/Los_Angeles],
             ~Y[2017-03-05 06:00:00 America/Los_Angeles]
           ]
  end

  test "Weekly; overridden start time" do
    times =
      ~Y[2017-01-01 06:00:00 America/Los_Angeles]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:weekly)
      |> Cocktail.Schedule.occurrences(~Y[2017-08-01 12:00:00 America/Los_Angeles])
      |> Enum.take(3)

    assert times == [
             ~Y[2017-08-06 06:00:00 America/Los_Angeles],
             ~Y[2017-08-13 06:00:00 America/Los_Angeles],
             ~Y[2017-08-20 06:00:00 America/Los_Angeles]
           ]
  end

  test "Weekly on the 10th and 14th hours of the day" do
    times =
      ~Y[2017-01-01 06:00:00 America/Los_Angeles]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:weekly, hours: [10, 14])
      |> Cocktail.Schedule.occurrences()
      |> Enum.take(5)

    assert times == [
             ~Y[2017-01-01 10:00:00 America/Los_Angeles],
             ~Y[2017-01-01 14:00:00 America/Los_Angeles],
             ~Y[2017-01-08 10:00:00 America/Los_Angeles],
             ~Y[2017-01-08 14:00:00 America/Los_Angeles],
             ~Y[2017-01-15 10:00:00 America/Los_Angeles]
           ]
  end

  test "Weekly on Mondays and Fridays" do
    times =
      ~Y[2017-01-01 06:00:00 America/Los_Angeles]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:weekly, days: [:monday, :friday])
      |> Cocktail.Schedule.occurrences()
      |> Enum.take(5)

    assert times == [
             ~Y[2017-01-02 06:00:00 America/Los_Angeles],
             ~Y[2017-01-06 06:00:00 America/Los_Angeles],
             ~Y[2017-01-09 06:00:00 America/Los_Angeles],
             ~Y[2017-01-13 06:00:00 America/Los_Angeles],
             ~Y[2017-01-16 06:00:00 America/Los_Angeles]
           ]
  end

  test "Every 2 weeks on Mondays and Fridays; starting on a sunday" do
    times =
      ~Y[2017-01-01 06:00:00 America/Los_Angeles]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:weekly, interval: 2, days: [:monday, :friday])
      |> Cocktail.Schedule.occurrences()
      |> Enum.take(5)

    assert times == [
             ~Y[2017-01-09 06:00:00 America/Los_Angeles],
             ~Y[2017-01-13 06:00:00 America/Los_Angeles],
             ~Y[2017-01-23 06:00:00 America/Los_Angeles],
             ~Y[2017-01-27 06:00:00 America/Los_Angeles],
             ~Y[2017-02-06 06:00:00 America/Los_Angeles]
           ]
  end

  test "Every 2 weeks on Mondays and Fridays; starting on a monday" do
    times =
      ~Y[2017-01-02 06:00:00 America/Los_Angeles]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:weekly, interval: 2, days: [:monday, :friday])
      |> Cocktail.Schedule.occurrences()
      |> Enum.take(5)

    assert times == [
             ~Y[2017-01-02 06:00:00 America/Los_Angeles],
             ~Y[2017-01-06 06:00:00 America/Los_Angeles],
             ~Y[2017-01-16 06:00:00 America/Los_Angeles],
             ~Y[2017-01-20 06:00:00 America/Los_Angeles],
             ~Y[2017-01-30 06:00:00 America/Los_Angeles]
           ]
  end

  test "Weekly on Mondays and Fridays on the 10th and 14th hours of the day" do
    times =
      ~Y[2017-01-01 06:00:00 America/Los_Angeles]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:weekly, hours: [10, 14], days: [:monday, :friday])
      |> Cocktail.Schedule.occurrences()
      |> Enum.take(5)

    assert times == [
             ~Y[2017-01-02 10:00:00 America/Los_Angeles],
             ~Y[2017-01-02 14:00:00 America/Los_Angeles],
             ~Y[2017-01-06 10:00:00 America/Los_Angeles],
             ~Y[2017-01-06 14:00:00 America/Los_Angeles],
             ~Y[2017-01-09 10:00:00 America/Los_Angeles]
           ]
  end

  test "Weekly with dst transition" do
    times =
      ~Y[2022-03-12 06:00:00 America/Los_Angeles]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:weekly)
      |> Cocktail.Schedule.occurrences()
      |> Enum.take(3)

    assert times == [
             ~Y[2022-03-12 06:00:00 America/Los_Angeles],
             ~Y[2022-03-19 06:00:00 America/Los_Angeles],
             ~Y[2022-03-26 06:00:00 America/Los_Angeles]
           ]
  end

  test "With count" do
    times =
      ~Y[2017-01-01 06:00:00 America/Los_Angeles]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:weekly, count: 3)
      |> Cocktail.Schedule.occurrences()
      |> Enum.take(50)

    assert times == [
             ~Y[2017-01-01 06:00:00 America/Los_Angeles],
             ~Y[2017-01-08 06:00:00 America/Los_Angeles],
             ~Y[2017-01-15 06:00:00 America/Los_Angeles]
           ]
  end

  test "Weekly on Saturday and Sunday with DST transition in Europe/Rome" do
    # Start: March 4, 2026 (Wednesday) at 01:00:00 Europe/Rome
    # Repeat: every Saturday and Sunday
    # Until: April 10, 2026
    # DST change: March 29, 2026 at 02:00 (clocks spring forward to 03:00)
    times =
      ~Y[2026-03-04 01:00:00 Europe/Rome]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:weekly, days: [:saturday, :sunday], until: ~Y[2026-04-10 23:59:59 Europe/Rome])
      |> Cocktail.Schedule.occurrences()
      |> Enum.to_list()

    assert times == [
             # Before DST (CET +01:00)
             ~Y[2026-03-07 01:00:00 Europe/Rome],
             ~Y[2026-03-08 01:00:00 Europe/Rome],
             ~Y[2026-03-14 01:00:00 Europe/Rome],
             ~Y[2026-03-15 01:00:00 Europe/Rome],
             ~Y[2026-03-21 01:00:00 Europe/Rome],
             ~Y[2026-03-22 01:00:00 Europe/Rome],
             ~Y[2026-03-28 01:00:00 Europe/Rome],
             ~Y[2026-03-29 01:00:00 Europe/Rome],
             # After DST (CEST +02:00)
             ~Y[2026-04-04 01:00:00 Europe/Rome],
             ~Y[2026-04-05 01:00:00 Europe/Rome]
           ]
  end
end
