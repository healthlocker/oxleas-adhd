defmodule Healthlocker.Clinician do
  use Healthlocker.Web, :model

  @primary_key false
  schema "clinicians" do
    belongs_to :clinician, Healthlocker.User
    belongs_to :caring, Healthlocker.User
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:clinician_id, :caring_id])
    |> validate_required([:clinician_id, :caring_id])
  end
end
