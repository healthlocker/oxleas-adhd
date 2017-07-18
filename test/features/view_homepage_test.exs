defmodule App.ViewHomepageTest do
  use App.FeatureCase, async: true

  test "shows a story", %{session: session} do
    page_body = session
      |> visit("/")
      |> find(Query.css("#body"))

    assert has_text?(page_body, "Welcome to Healthlocker")
  end
end
