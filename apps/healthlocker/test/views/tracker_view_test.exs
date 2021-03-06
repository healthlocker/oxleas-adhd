defmodule Healthlocker.TrackerViewTest do
  use Healthlocker.ConnCase, async: true
  alias Healthlocker.{TrackerView, SleepTracker}

  doctest TrackerView

  @data [%SleepTracker{
    for_date: ~D[2017-04-07],
    hours_slept: "8.0",
    wake_count: "0"},
   %SleepTracker{
    for_date: ~D[2017-04-09],
    hours_slept: "7.0",
    wake_count: "1"}]

  test "get_week_average returns the correct weekly average" do
    actual = TrackerView.get_week_average(@data)
    expected = "7h 30m"
    assert actual == expected
  end

  test "format_sleep_hours returns a comma separated string of hours" do
    actual = TrackerView.format_sleep_hours(@data)
    expected = "7.0,null,null,null,null,8.0,null"
    assert actual == expected
  end

  test "format_sleep_dates returns a comma separated string of dates" do
    actual = TrackerView.format_sleep_dates("2017-04-10")
    expected = "09/04,10/04,04/04,05/04,06/04,07/04,08/04"
    assert actual == expected
  end

  test "date_with_day_and_month returns the correct date string" do
    actual = TrackerView.date_with_day_and_month(~D[2017-04-07])
    expected = "Friday 7 April"
    assert actual == expected
  end

  test "printed_time while in BST" do
    actual = TrackerView.printed_time(~N[2017-09-20 12:22:06.896685])
    expected = "13:22"
    assert actual == expected
  end

  test "printed_time while not in BST" do
    actual = TrackerView.printed_time(~N[2000-01-01 11:00:07])
    expected = "11:00"
    assert actual == expected
  end

  describe "date_with_day_and_month returns the correct date string" do
    setup do
      [
        range: [ ~D[2018-01-01], ~D[2018-01-02], ~D[2018-01-03], ~D[2018-01-04], ~D[2018-01-05], ~D[2018-01-06], ~D[2018-01-07] ],
        dates: ["Monday 1 January", "Tuesday 2 January", "Wednesday 3 January", "Thursday 4 January", "Friday 5 January", "Saturday 6 January", "Sunday 7 January"]
      ]
    end

    test "days", fixture do
      Enum.each(0..6, fn(x) ->
        actual = TrackerView.date_with_day_and_month(Enum.at(fixture.range, x))
        assert actual == Enum.at(fixture.dates, x)
      end)
    end
  end
end
