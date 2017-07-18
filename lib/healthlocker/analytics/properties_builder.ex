defmodule App.Analytics.PropertiesBuilder do
  @moduledoc """
  Used for building a properties map from a model.
  """

  def build(model), do: properties(model)

  defp properties(%App.Goal{} = goal) do
    %{
      important: goal.important
    }
  end

  defp properties(%App.Post{}), do: %{}
  defp properties(%App.SleepTracker{} = sleep_data) do
    %{
      notes: !!sleep_data.notes
    }
  end
end
