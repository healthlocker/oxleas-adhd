defmodule Healthlocker.OxleasAdhd.MedicationView do
  use Healthlocker.Web, :view
  use Timex

  # reformats datetime to DD/MM/YYYY
  def format_date(datetime) do
    datetime
    |> Timex.format!("{0D}/{0M}/{YYYY}")
  end
end
