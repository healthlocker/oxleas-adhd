defmodule OxleasAdhd.MedicationView do
  use OxleasAdhd.Web, :view
  use Timex

  # reformats datetime to DD/MM/YYYY
  def format_date(datetime) do
    IO.inspect datetime
    datetime
    |> Timex.format!("{0D}/{0M}/{YYYY}")
  end
end
