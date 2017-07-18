defmodule App.ComponentHelpers do
  @moduledoc """
  Convience methods for rendering our components.
  """

  @doc false
  defmacro __using__(_) do
    quote do
      import App.ComponentHelpers.Button
      import App.ComponentHelpers.Link
    end
  end
end
