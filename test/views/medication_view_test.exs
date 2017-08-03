defmodule OxleasAdhd.MedicationViewTest do
  use OxleasAdhd.ConnCase, async: true
  alias OxleasAdhd.MedicationView

  test "format date returns datetime as dd/mm/yyyy" do
    {:ok, datetime} = NaiveDateTime.new(~D[2010-01-13], ~T[23:00:07.005])
    actual = MedicationView.format_date(datetime)
    expected = "13/01/2010"
  end
end
