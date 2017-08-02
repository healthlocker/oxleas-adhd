defmodule OxleasAdhd.ClinicianRooms do
  use OxleasAdhd.Web, :model

  schema "clinician_rooms" do
    belongs_to :room, OxleasAdhd.Room
    field :clinician_id, :integer

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:clinician_id, :room_id])
    |> validate_required([:clinician_id, :room_id])
    |> unique_constraint(:clinician_id, name: :clinician_rooms_clinician_id_room_id_index)
  end
end
