defmodule App.Analytics.EventNameBuilder do
  @moduledoc """
  Build event names based on the model and action performed.
  """

  def build(action, model), do: event_name(action, model)

  defp event_name(:create, %App.Goal{}), do: "Goal Created"

  defp event_name(:create, %App.Post{}), do: "Strategy Created"

  defp event_name(:create, %App.SleepTracker{}), do: "Night's Sleep Tracked"

end
