defmodule App.Analytics.LocalTest do
  use ExUnit.Case, async: true

  test "identify/2" do
    assert App.Analytics.Local.identify("12345", {}) == :ok
  end

  test "track/3" do
    status = App.Analytics.Local.track("12345", "signed_up", {})
    assert status == :ok
  end
end
