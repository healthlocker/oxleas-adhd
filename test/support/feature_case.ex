defmodule App.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL

      alias App.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import App.Router.Helpers
      import App.LoginHelpers
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(App.Repo)
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(App.ReadOnlyRepo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(App.Repo, {:shared, self()})
      Ecto.Adapters.SQL.Sandbox.mode(App.ReadOnlyRepo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(App.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    {:ok, session: session}
  end
end
