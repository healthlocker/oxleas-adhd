defmodule App.Symptom do
  use App.Web, :model

  schema "symptoms" do
    field :symptom, :string, null: false
    belongs_to :user, App.User
    has_many :symptom_trackers, App.SymptomTracker, on_replace: :delete

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:symptom])
    |> validate_required([:symptom])
  end
end
