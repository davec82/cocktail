defmodule Cocktail.YearlyTest do
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

  test "Yearly" do
    schedule =
      ~Y[2017-01-01 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly)

    assert first_n_occurrences(schedule, 3) == [
             ~Y[2017-01-01 06:00:00 UTC],
             ~Y[2018-01-01 06:00:00 UTC],
             ~Y[2019-01-01 06:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Yearly starting on 11th March 2017" do
    schedule =
      ~Y[2017-03-11 19:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, interval: 1)

    assert first_n_occurrences(schedule, 3) == [
             ~Y[2017-03-11 19:00:00 UTC],
             ~Y[2018-03-11 19:00:00 UTC],
             ~Y[2019-03-11 19:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Yearly starting on 1st January 2017" do
    schedule =
      ~Y[2017-01-01 19:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, interval: 1)

    assert first_n_occurrences(schedule, 3) == [
             ~Y[2017-01-01 19:00:00 UTC],
             ~Y[2018-01-01 19:00:00 UTC],
             ~Y[2019-01-01 19:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Yearly starting on 31th December 2017" do
    schedule =
      ~Y[2017-12-31 19:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, interval: 1)

    assert first_n_occurrences(schedule, 3) == [
             ~Y[2017-12-31 19:00:00 UTC],
             ~Y[2018-12-31 19:00:00 UTC],
             ~Y[2019-12-31 19:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Yearly starting on 29th February 2016" do
    schedule =
      ~Y[2016-02-29 19:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, interval: 1)

    assert first_n_occurrences(schedule, 3) == [
             ~Y[2016-02-29 19:00:00 UTC],
             ~Y[2020-02-29 19:00:00 UTC],
             ~Y[2024-02-29 19:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Yearly starting on 31th March 2016" do
    schedule =
      ~Y[2016-03-31 19:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, interval: 1)

    assert first_n_occurrences(schedule, 3) == [
             ~Y[2016-03-31 19:00:00 UTC],
             ~Y[2017-03-31 19:00:00 UTC],
             ~Y[2018-03-31 19:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Every 2 years" do
    schedule =
      ~Y[2017-02-28 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, interval: 2)

    assert first_n_occurrences(schedule, 3) == [
             ~Y[2017-02-28 06:00:00 UTC],
             ~Y[2019-02-28 06:00:00 UTC],
             ~Y[2021-02-28 06:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Every 2 years on new year's day" do
    schedule =
      ~Y[2017-01-01 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, interval: 2)

    assert first_n_occurrences(schedule, 3) == [
             ~Y[2017-01-01 06:00:00 UTC],
             ~Y[2019-01-01 06:00:00 UTC],
             ~Y[2021-01-01 06:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Every 2 years starting on 29th February 2016" do
    schedule =
      ~Y[2016-02-29 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, interval: 2)

    assert first_n_occurrences(schedule, 5) == [
             ~Y[2016-02-29 06:00:00 UTC],
             ~Y[2020-02-29 06:00:00 UTC],
             ~Y[2024-02-29 06:00:00 UTC],
             ~Y[2028-02-29 06:00:00 UTC],
             ~Y[2032-02-29 06:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Every 7 years starting on 29th February 2016" do
    schedule =
      ~Y[2016-02-29 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, interval: 7)

    assert first_n_occurrences(schedule, 5) == [
             ~Y[2016-02-29 06:00:00 UTC],
             ~Y[2044-02-29 06:00:00 UTC],
             ~Y[2072-02-29 06:00:00 UTC],
             ~Y[2128-02-29 06:00:00 UTC],
             ~Y[2156-02-29 06:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Every 2 / 3 years" do
    schedule =
      ~Y[2017-01-18 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, interval: 2)
      |> Schedule.add_recurrence_rule(:yearly, interval: 3)

    assert first_n_occurrences(schedule, 7) == [
             ~Y[2017-01-18 06:00:00 UTC],
             ~Y[2019-01-18 06:00:00 UTC],
             ~Y[2020-01-18 06:00:00 UTC],
             ~Y[2021-01-18 06:00:00 UTC],
             ~Y[2023-01-18 06:00:00 UTC],
             ~Y[2025-01-18 06:00:00 UTC],
             ~Y[2026-01-18 06:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Every 2 / 3 years starting on 2nd January 2017" do
    schedule =
      ~Y[2017-01-02 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, interval: 2)
      |> Schedule.add_recurrence_rule(:yearly, interval: 3)

    assert first_n_occurrences(schedule, 7) == [
             ~Y[2017-01-02 06:00:00 UTC],
             ~Y[2019-01-02 06:00:00 UTC],
             ~Y[2020-01-02 06:00:00 UTC],
             ~Y[2021-01-02 06:00:00 UTC],
             ~Y[2023-01-02 06:00:00 UTC],
             ~Y[2025-01-02 06:00:00 UTC],
             ~Y[2026-01-02 06:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Yearly on Mondays" do
    schedule =
      ~Y[2022-12-18 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, days: [:monday])

    assert first_n_occurrences(schedule, 5) == [
             ~Y[2022-12-19 06:00:00 UTC],
             ~Y[2022-12-26 06:00:00 UTC],
             ~Y[2023-01-02 06:00:00 UTC],
             ~Y[2023-01-09 06:00:00 UTC],
             ~Y[2023-01-16 06:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "On Mondays every 2 years" do
    schedule =
      ~Y[2022-12-18 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, days: [:monday], interval: 2)

    assert first_n_occurrences(schedule, 5) == [
             ~Y[2022-12-19 06:00:00 UTC],
             ~Y[2022-12-26 06:00:00 UTC],
             ~Y[2024-01-01 06:00:00 UTC],
             ~Y[2024-01-08 06:00:00 UTC],
             ~Y[2024-01-15 06:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Yearly on Mondays and Fridays and day of month" do
    schedule =
      ~Y[2022-12-18 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, days: [:monday, :friday], days_of_month: [18])

    assert first_n_occurrences(schedule, 8) == [
             ~Y[2023-08-18 06:00:00 UTC],
             ~Y[2023-09-18 06:00:00 UTC],
             ~Y[2023-12-18 06:00:00 UTC],
             ~Y[2024-03-18 06:00:00 UTC],
             ~Y[2024-10-18 06:00:00 UTC],
             ~Y[2024-11-18 06:00:00 UTC],
             ~Y[2025-04-18 06:00:00 UTC],
             ~Y[2025-07-18 06:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Yearly on Mondays and Fridays and first day of month" do
    schedule =
      ~Y[2022-05-18 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, days: [:monday, :friday], days_of_month: [1])

    assert first_n_occurrences(schedule, 8) == [
             ~Y[2022-07-01 06:00:00 UTC],
             ~Y[2022-08-01 06:00:00 UTC],
             ~Y[2023-05-01 06:00:00 UTC],
             ~Y[2023-09-01 06:00:00 UTC],
             ~Y[2023-12-01 06:00:00 UTC],
             ~Y[2024-01-01 06:00:00 UTC],
             ~Y[2024-03-01 06:00:00 UTC],
             ~Y[2024-04-01 06:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "On Mondays and Fridays and day of month every 2 years" do
    schedule =
      ~Y[2022-12-18 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, days: [:monday, :friday], days_of_month: [18], interval: 2)

    assert first_n_occurrences(schedule, 8) == [
             ~Y[2024-03-18 06:00:00 UTC],
             ~Y[2024-10-18 06:00:00 UTC],
             ~Y[2024-11-18 06:00:00 UTC],
             ~Y[2026-05-18 06:00:00 UTC],
             ~Y[2026-09-18 06:00:00 UTC],
             ~Y[2026-12-18 06:00:00 UTC],
             ~Y[2028-02-18 06:00:00 UTC],
             ~Y[2028-08-18 06:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Yearly on the 10th and 14th hours of the day" do
    schedule =
      ~Y[2017-01-01 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, hours: [10, 14])

    assert first_n_occurrences(schedule, 6) == [
             ~Y[2017-01-01 10:00:00 UTC],
             ~Y[2017-01-01 14:00:00 UTC],
             ~Y[2018-01-01 10:00:00 UTC],
             ~Y[2018-01-01 14:00:00 UTC],
             ~Y[2019-01-01 10:00:00 UTC],
             ~Y[2019-01-01 14:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Yearly in June and July" do
    schedule =
      ~Y[1997-06-10 10:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, months_of_year: [6, 7])

    assert first_n_occurrences(schedule, 6) == [
             ~Y[1997-06-10 10:00:00 UTC],
             ~Y[1997-07-10 10:00:00 UTC],
             ~Y[1998-06-10 10:00:00 UTC],
             ~Y[1998-07-10 10:00:00 UTC],
             ~Y[1999-06-10 10:00:00 UTC],
             ~Y[1999-07-10 10:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Yearly in March and July starting on February" do
    schedule =
      ~Y[1997-01-30 10:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, months_of_year: [3, 7])

    assert first_n_occurrences(schedule, 6) == [
             ~Y[1997-03-30 10:00:00 UTC],
             ~Y[1997-07-30 10:00:00 UTC],
             ~Y[1998-03-30 10:00:00 UTC],
             ~Y[1998-07-30 10:00:00 UTC],
             ~Y[1999-03-30 10:00:00 UTC],
             ~Y[1999-07-30 10:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Every other year on January, February, and March" do
    schedule =
      ~Y[1997-03-10 10:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, months_of_year: [1, 2, 3], interval: 2)

    assert first_n_occurrences(schedule, 7) == [
             ~Y[1997-03-10 10:00:00 UTC],
             ~Y[1999-01-10 10:00:00 UTC],
             ~Y[1999-02-10 10:00:00 UTC],
             ~Y[1999-03-10 10:00:00 UTC],
             ~Y[2001-01-10 10:00:00 UTC],
             ~Y[2001-02-10 10:00:00 UTC],
             ~Y[2001-03-10 10:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Every Thursday in March" do
    schedule =
      ~Y[1997-03-13 10:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, months_of_year: [3], days: [:thursday])

    assert first_n_occurrences(schedule, 11) == [
             ~Y[1997-03-13 10:00:00 UTC],
             ~Y[1997-03-20 10:00:00 UTC],
             ~Y[1997-03-27 10:00:00 UTC],
             ~Y[1998-03-05 10:00:00 UTC],
             ~Y[1998-03-12 10:00:00 UTC],
             ~Y[1998-03-19 10:00:00 UTC],
             ~Y[1998-03-26 10:00:00 UTC],
             ~Y[1999-03-04 10:00:00 UTC],
             ~Y[1999-03-11 10:00:00 UTC],
             ~Y[1999-03-18 10:00:00 UTC],
             ~Y[1999-03-25 10:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Every Thursday, but only during June, July, and August" do
    schedule =
      ~Y[1997-06-05 10:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, months_of_year: [6, 7, 8], days: [:thursday])

    assert first_n_occurrences(schedule, 27) == [
             ~Y[1997-06-05 10:00:00 UTC],
             ~Y[1997-06-12 10:00:00 UTC],
             ~Y[1997-06-19 10:00:00 UTC],
             ~Y[1997-06-26 10:00:00 UTC],
             ~Y[1997-07-03 10:00:00 UTC],
             ~Y[1997-07-10 10:00:00 UTC],
             ~Y[1997-07-17 10:00:00 UTC],
             ~Y[1997-07-24 10:00:00 UTC],
             ~Y[1997-07-31 10:00:00 UTC],
             ~Y[1997-08-07 10:00:00 UTC],
             ~Y[1997-08-14 10:00:00 UTC],
             ~Y[1997-08-21 10:00:00 UTC],
             ~Y[1997-08-28 10:00:00 UTC],
             ~Y[1998-06-04 10:00:00 UTC],
             ~Y[1998-06-11 10:00:00 UTC],
             ~Y[1998-06-18 10:00:00 UTC],
             ~Y[1998-06-25 10:00:00 UTC],
             ~Y[1998-07-02 10:00:00 UTC],
             ~Y[1998-07-09 10:00:00 UTC],
             ~Y[1998-07-16 10:00:00 UTC],
             ~Y[1998-07-23 10:00:00 UTC],
             ~Y[1998-07-30 10:00:00 UTC],
             ~Y[1998-08-06 10:00:00 UTC],
             ~Y[1998-08-13 10:00:00 UTC],
             ~Y[1998-08-20 10:00:00 UTC],
             ~Y[1998-08-27 10:00:00 UTC],
             ~Y[1999-06-03 10:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Every 4 years, the first Tuesday after a Monday in November" do
    schedule =
      ~Y[1996-11-05 10:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly,
        interval: 4,
        months_of_year: [11],
        days: [:tuesday],
        days_of_month: [2, 3, 4, 5, 6, 7, 8]
      )

    assert first_n_occurrences(schedule, 11) == [
             ~Y[1996-11-05 10:00:00 UTC],
             ~Y[2000-11-07 10:00:00 UTC],
             ~Y[2004-11-02 10:00:00 UTC],
             ~Y[2008-11-04 10:00:00 UTC],
             ~Y[2012-11-06 10:00:00 UTC],
             ~Y[2016-11-08 10:00:00 UTC],
             ~Y[2020-11-03 10:00:00 UTC],
             ~Y[2024-11-05 10:00:00 UTC],
             ~Y[2028-11-07 10:00:00 UTC],
             ~Y[2032-11-02 10:00:00 UTC],
             ~Y[2036-11-04 10:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end

  test "Yearly on xmas on sunday" do
    schedule =
      ~Y[2022-12-25 06:00:00 UTC]
      |> Cocktail.schedule()
      |> Schedule.add_recurrence_rule(:yearly, days: [:sunday], months_of_year: [12], days_of_month: [25])

    assert first_n_occurrences(schedule, 8) == [
             ~Y[2022-12-25 06:00:00 UTC],
             ~Y[2033-12-25 06:00:00 UTC],
             ~Y[2039-12-25 06:00:00 UTC],
             ~Y[2044-12-25 06:00:00 UTC],
             ~Y[2050-12-25 06:00:00 UTC],
             ~Y[2061-12-25 06:00:00 UTC],
             ~Y[2067-12-25 06:00:00 UTC],
             ~Y[2072-12-25 06:00:00 UTC]
           ]

    assert_icalendar_preserved(schedule)
  end
end
