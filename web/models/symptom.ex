defmodule OxleasAdhd.Symptom do
  use OxleasAdhd.Web, :model

  schema "symptoms" do
    field :symptom, :string, null: false
    belongs_to :user, OxleasAdhd.User
    has_many :symptom_trackers, OxleasAdhd.SymptomTracker, on_replace: :delete

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:symptom])
    |> validate_required([:symptom])
  end
end
