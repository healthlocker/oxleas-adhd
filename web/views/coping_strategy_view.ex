defmodule App.CopingStrategyView do
  use App.Web, :view

  def markdown(body) do
    body
    |> Earmark.as_html!
    |> raw
  end
end
