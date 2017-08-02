defmodule OxleasAdhd.Medication do
  use OxleasAdhd.Web, :model

  schema "medications" do
    field :name, :string
    field :dosage, :string
    field :frequency, :string
    field :other_medicine, :string
    field :allergies, :string
    field :past_medication, :string
    belongs_to :user, OxleasAdhd.User

    timestamps()
  end

  def changeset(struct, params \\ :invalid) do
    struct
    |> cast(params, [:name, :dosage, :frequency, :other_medicine, :allergies])
    |> validate_required([:name, :dosage, :frequency])
  end
end
