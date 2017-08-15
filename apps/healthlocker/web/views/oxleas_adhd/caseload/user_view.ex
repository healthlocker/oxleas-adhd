defmodule Healthlocker.OxleasAdhd.Caseload.UserView do
  use Healthlocker.Web, :view

  def markdown(body) do
    body
    |> Earmark.as_html!
    |> raw
  end
end
