defmodule App.Caseload.UserView do
  use App.Web, :view

  def format_nhs_number(nhs_number) do
    String.slice(nhs_number, 0, 3) <> " " <> String.slice(nhs_number, 3, 3) <> " " <>
      String.slice(nhs_number, 6, 4)
  end

  def markdown(body) do
    body
    |> Earmark.as_html!
    |> raw
  end

end
