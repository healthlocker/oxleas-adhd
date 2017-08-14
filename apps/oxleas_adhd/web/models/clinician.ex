defmodule OxleasAdhd.Clinician do
  use OxleasAdhd.Web, :model

  @primary_key false
  schema "clinicians" do
    belongs_to :clinician, OxleasAdhd.User
    belongs_to :caring, OxleasAdhd.User
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:clinician_id, :caring_id])
    |> validate_required([:clinician_id, :caring_id])
  end
end
