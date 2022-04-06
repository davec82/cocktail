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
end
