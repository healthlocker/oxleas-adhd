defmodule Healthlocker.Analytics.Segment do
  @moduledoc """
  Interface to the Segment API via [`analytics-elixir`](https://github.com/stueccles/analytics-elixir)
  """

  def identify(user_id, traits) do
    Segment.Analytics.identify(user_id, traits)
  end

  def track(user_id, event_name, properties) do
    Segment.Analytics.track(user_id, event_name, properties)
  end
end
