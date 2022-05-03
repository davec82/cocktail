defmodule Cocktail.NdayTest do
  use ExUnit.Case

  alias Cocktail.Schedule

  import Cocktail.TestSupport.DateTimeSigil

  @spec first_n_occurrences(%Cocktail.Schedule{}, integer()) :: term
  def first_n_occurrences(schedule, n \\ 20) do
    schedule
    |> Cocktail.Schedule.occurrences()
    |> Enum.take(n)
  end

  @spec assert_icalendar_preserved(%Cocktail.Schedule{}) :: %Cocktail.Schedule{}
  defp assert_icalendar_preserved(schedule) do
    {:ok, preserved_schedule} =
      schedule
      |> Cocktail.Schedule.to_i_calendar()
      |> Cocktail.Schedule.from_i_calendar()

    assert first_n_occurrences(schedule) == first_n_occurrences(preserved_schedule)
  end

  test "Monthly on 3rd Sunday and Saturday" do
    schedule =
      ~Y[2022-04-08 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:monthly, ndays: [{3, :sunday}, {3, :saturday}])

    assert first_n_occurrences(schedule, 9) == [
             ~Y[2022-04-16 06:00:00 UTC],
             ~Y[2022-04-17 06:00:00 UTC],
             ~Y[2022-05-15 06:00:00 UTC],
             ~Y[2022-05-21 06:00:00 UTC],
             ~Y[2022-06-18 06:00:00 UTC],
             ~Y[2022-06-19 06:00:00 UTC],
             ~Y[2022-07-16 06:00:00 UTC],
             ~Y[2022-07-17 06:00:00 UTC],
             ~Y[2022-08-20 06:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Monthly on 3rd Sunday and Saturday using day integer" do
    schedule =
      ~Y[2022-04-08 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:monthly, ndays: [{3, 0}, {3, 6}])

    assert first_n_occurrences(schedule, 9) == [
             ~Y[2022-04-16 06:00:00 UTC],
             ~Y[2022-04-17 06:00:00 UTC],
             ~Y[2022-05-15 06:00:00 UTC],
             ~Y[2022-05-21 06:00:00 UTC],
             ~Y[2022-06-18 06:00:00 UTC],
             ~Y[2022-06-19 06:00:00 UTC],
             ~Y[2022-07-16 06:00:00 UTC],
             ~Y[2022-07-17 06:00:00 UTC],
             ~Y[2022-08-20 06:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Monthly on 3rd Sunday and Saturday using plus sing" do
    schedule =
      ~Y[2022-04-08 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:monthly, ndays: [{+3, :sunday}, {+3, :saturday}])

    assert first_n_occurrences(schedule, 9) == [
             ~Y[2022-04-16 06:00:00 UTC],
             ~Y[2022-04-17 06:00:00 UTC],
             ~Y[2022-05-15 06:00:00 UTC],
             ~Y[2022-05-21 06:00:00 UTC],
             ~Y[2022-06-18 06:00:00 UTC],
             ~Y[2022-06-19 06:00:00 UTC],
             ~Y[2022-07-16 06:00:00 UTC],
             ~Y[2022-07-17 06:00:00 UTC],
             ~Y[2022-08-20 06:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Every other month on 3rd Sunday and Saturday" do
    schedule =
      ~Y[2022-04-08 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:monthly, interval: 2, ndays: [{3, :sunday}, {3, :saturday}])

    assert first_n_occurrences(schedule, 9) == [
             ~Y[2022-04-16 06:00:00 UTC],
             ~Y[2022-04-17 06:00:00 UTC],
             ~Y[2022-06-18 06:00:00 UTC],
             ~Y[2022-06-19 06:00:00 UTC],
             ~Y[2022-08-20 06:00:00 UTC],
             ~Y[2022-08-21 06:00:00 UTC],
             ~Y[2022-10-15 06:00:00 UTC],
             ~Y[2022-10-16 06:00:00 UTC],
             ~Y[2022-12-17 06:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Every other month on the first and last Sunday of the month" do
    schedule =
      ~Y[1997-09-07 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:monthly, interval: 2, ndays: [{1, :sunday}, {-1, :sunday}])

    assert first_n_occurrences(schedule, 9) == [
             ~Y[1997-09-07 06:00:00 UTC],
             ~Y[1997-09-28 06:00:00 UTC],
             ~Y[1997-11-02 06:00:00 UTC],
             ~Y[1997-11-30 06:00:00 UTC],
             ~Y[1998-01-04 06:00:00 UTC],
             ~Y[1998-01-25 06:00:00 UTC],
             ~Y[1998-03-01 06:00:00 UTC],
             ~Y[1998-03-29 06:00:00 UTC],
             ~Y[1998-05-03 06:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Monthly on the second-to-last Monday of the month" do
    schedule =
      ~Y[1997-09-22 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:monthly, ndays: [{-2, :monday}])

    assert first_n_occurrences(schedule, 9) == [
             ~Y[1997-09-22 06:00:00 UTC],
             ~Y[1997-10-20 06:00:00 UTC],
             ~Y[1997-11-17 06:00:00 UTC],
             ~Y[1997-12-22 06:00:00 UTC],
             ~Y[1998-01-19 06:00:00 UTC],
             ~Y[1998-02-16 06:00:00 UTC],
             ~Y[1998-03-23 06:00:00 UTC],
             ~Y[1998-04-20 06:00:00 UTC],
             ~Y[1998-05-18 06:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Monthly on the 5th Friday of the month" do
    schedule =
      ~Y[1997-09-22 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:monthly, ndays: [{5, :friday}])

    assert first_n_occurrences(schedule, 10) == [
             ~Y[1997-10-31 06:00:00 UTC],
             ~Y[1998-01-30 06:00:00 UTC],
             ~Y[1998-05-29 06:00:00 UTC],
             ~Y[1998-07-31 06:00:00 UTC],
             ~Y[1998-10-30 06:00:00 UTC],
             ~Y[1999-01-29 06:00:00 UTC],
             ~Y[1999-04-30 06:00:00 UTC],
             ~Y[1999-07-30 06:00:00 UTC],
             ~Y[1999-10-29 06:00:00 UTC],
             ~Y[1999-12-31 06:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Every 20th Monday of the year" do
    schedule =
      ~Y[1997-05-19 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, ndays: [{20, :monday}])

    assert first_n_occurrences(schedule, 10) == [
             ~Y[1997-05-19 06:00:00 UTC],
             ~Y[1998-05-18 06:00:00 UTC],
             ~Y[1999-05-17 06:00:00 UTC],
             ~Y[2000-05-15 06:00:00 UTC],
             ~Y[2001-05-14 06:00:00 UTC],
             ~Y[2002-05-20 06:00:00 UTC],
             ~Y[2003-05-19 06:00:00 UTC],
             ~Y[2004-05-17 06:00:00 UTC],
             ~Y[2005-05-16 06:00:00 UTC],
             ~Y[2006-05-15 06:00:00 UTC]
           ]
  end

  test "Every 20th Monday of other year" do
    schedule =
      ~Y[1997-05-19 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, interval: 2, ndays: [{20, :monday}])

    assert first_n_occurrences(schedule, 10) == [
             ~Y[1997-05-19 06:00:00 UTC],
             ~Y[1999-05-17 06:00:00 UTC],
             ~Y[2001-05-14 06:00:00 UTC],
             ~Y[2003-05-19 06:00:00 UTC],
             ~Y[2005-05-16 06:00:00 UTC],
             ~Y[2007-05-14 06:00:00 UTC],
             ~Y[2009-05-18 06:00:00 UTC],
             ~Y[2011-05-16 06:00:00 UTC],
             ~Y[2013-05-20 06:00:00 UTC],
             ~Y[2015-05-18 06:00:00 UTC]
           ]
  end

  test "Every 3rd Friday and 20th Monday of the year" do
    schedule =
      ~Y[1997-05-19 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, ndays: [{20, :monday}, {3, :friday}])

    assert first_n_occurrences(schedule, 10) == [
             ~Y[1997-05-19 06:00:00 UTC],
             ~Y[1998-01-16 06:00:00 UTC],
             ~Y[1998-05-18 06:00:00 UTC],
             ~Y[1999-01-15 06:00:00 UTC],
             ~Y[1999-05-17 06:00:00 UTC],
             ~Y[2000-01-21 06:00:00 UTC],
             ~Y[2000-05-15 06:00:00 UTC],
             ~Y[2001-01-19 06:00:00 UTC],
             ~Y[2001-05-14 06:00:00 UTC],
             ~Y[2002-01-18 06:00:00 UTC]
           ]
  end

  test "Every last 6th Sunday of the year" do
    schedule =
      ~Y[1997-05-19 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, ndays: [{-6, :sunday}])

    assert first_n_occurrences(schedule, 10) == [
             ~Y[1997-11-23 06:00:00 UTC],
             ~Y[1998-11-22 06:00:00 UTC],
             ~Y[1999-11-21 06:00:00 UTC],
             ~Y[2000-11-26 06:00:00 UTC],
             ~Y[2001-11-25 06:00:00 UTC],
             ~Y[2002-11-24 06:00:00 UTC],
             ~Y[2003-11-23 06:00:00 UTC],
             ~Y[2004-11-21 06:00:00 UTC],
             ~Y[2005-11-20 06:00:00 UTC],
             ~Y[2006-11-26 06:00:00 UTC]
           ]
  end

  test "Every last Tuesday and last Thursday of the year" do
    schedule =
      ~Y[1997-05-19 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, ndays: [{-1, :thursday}, {-1, :tuesday}])

    assert first_n_occurrences(schedule, 10) == [
             ~Y[1997-12-25 06:00:00 UTC],
             ~Y[1997-12-30 06:00:00 UTC],
             ~Y[1998-12-29 06:00:00 UTC],
             ~Y[1998-12-31 06:00:00 UTC],
             ~Y[1999-12-28 06:00:00 UTC],
             ~Y[1999-12-30 06:00:00 UTC],
             ~Y[2000-12-26 06:00:00 UTC],
             ~Y[2000-12-28 06:00:00 UTC],
             ~Y[2001-12-25 06:00:00 UTC],
             ~Y[2001-12-27 06:00:00 UTC]
           ]
  end

  test "Every other year last 10th Wednesday of the year" do
    schedule =
      ~Y[1997-05-19 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, interval: 2, ndays: [{-10, :wednesday}])

    assert first_n_occurrences(schedule, 10) == [
             ~Y[1997-10-29 06:00:00 UTC],
             ~Y[1999-10-27 06:00:00 UTC],
             ~Y[2001-10-24 06:00:00 UTC],
             ~Y[2003-10-29 06:00:00 UTC],
             ~Y[2005-10-26 06:00:00 UTC],
             ~Y[2007-10-24 06:00:00 UTC],
             ~Y[2009-10-28 06:00:00 UTC],
             ~Y[2011-10-26 06:00:00 UTC],
             ~Y[2013-10-23 06:00:00 UTC],
             ~Y[2015-10-28 06:00:00 UTC]
           ]
  end

  test "Every 1st Sunday and last Sunday of the year" do
    schedule =
      ~Y[1997-05-19 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, ndays: [{-1, :sunday}, {1, :sunday}])

    assert first_n_occurrences(schedule, 10) == [
             ~Y[1997-12-28 06:00:00 UTC],
             ~Y[1998-01-04 06:00:00 UTC],
             ~Y[1998-12-27 06:00:00 UTC],
             ~Y[1999-01-03 06:00:00 UTC],
             ~Y[1999-12-26 06:00:00 UTC],
             ~Y[2000-01-02 06:00:00 UTC],
             ~Y[2000-12-31 06:00:00 UTC],
             ~Y[2001-01-07 06:00:00 UTC],
             ~Y[2001-12-30 06:00:00 UTC],
             ~Y[2002-01-06 06:00:00 UTC]
           ]
  end

  test "Yearly 4th Friday on April" do
    schedule =
      ~Y[1997-05-19 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, ndays: [{4, :friday}], months_of_year: [4])

    assert first_n_occurrences(schedule, 10) == [
             ~Y[1998-04-24 06:00:00 UTC],
             ~Y[1999-04-23 06:00:00 UTC],
             ~Y[2000-04-28 06:00:00 UTC],
             ~Y[2001-04-27 06:00:00 UTC],
             ~Y[2002-04-26 06:00:00 UTC],
             ~Y[2003-04-25 06:00:00 UTC],
             ~Y[2004-04-23 06:00:00 UTC],
             ~Y[2005-04-22 06:00:00 UTC],
             ~Y[2006-04-28 06:00:00 UTC],
             ~Y[2007-04-27 06:00:00 UTC]
           ]
  end

  test "Yearly 4th Friday on April starting on January" do
    schedule =
      ~Y[1997-01-30 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, ndays: [{4, :friday}], months_of_year: [4])

    assert first_n_occurrences(schedule, 10) == [
             ~Y[1997-04-25 06:00:00 UTC],
             ~Y[1998-04-24 06:00:00 UTC],
             ~Y[1999-04-23 06:00:00 UTC],
             ~Y[2000-04-28 06:00:00 UTC],
             ~Y[2001-04-27 06:00:00 UTC],
             ~Y[2002-04-26 06:00:00 UTC],
             ~Y[2003-04-25 06:00:00 UTC],
             ~Y[2004-04-23 06:00:00 UTC],
             ~Y[2005-04-22 06:00:00 UTC],
             ~Y[2006-04-28 06:00:00 UTC]
           ]
  end
end
