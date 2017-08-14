defmodule OxleasAdhd.CreateCarerRooms do
  alias Ecto.Multi
  alias OxleasAdhd.{Room, UserRoom, Repo, ClinicianRooms, Carer}

  def connect_carers_and_create_rooms(carer, service_user, clinician_ids) do
    Multi.new
    |> Multi.insert(:carer, Carer.changeset(%Carer{carer_id: carer.id, caring_id: service_user.id}))
    |> Multi.insert(:room, Room.changeset(%Room{
      name: "carer-care-team:" <> Integer.to_string(carer.id)
    }))
    |> Multi.run(:carer_room, &add_su_to_room(&1, carer))
    |> Multi.run(:clinician_room, &add_clinicians_to_room(&1, clinician_ids))
  end

  defp add_su_to_room(multi, user) do
    changeset = UserRoom.changeset(%UserRoom{
      user_id: user.id,
      room_id: multi.room.id
    })
    case Repo.insert(changeset) do
      {:ok, user_room} ->
        {:ok, user_room}
      {:error, changeset} ->
        {:error, changeset, "Error adding user to room"}
    end
  end

  defp add_clinicians_to_room(multi, clinician_ids) do
    clinicians = clinician_ids |> make_clinicians(multi.room.id)

    case Repo.insert_all(ClinicianRooms, clinicians) do
      {n, nil} ->
        {:ok, n}
      _err ->
        {:error, "Error adding clinician to room"}
    end
  end

  defp make_clinicians(clinician_ids, room_id) do
  clinician_ids
  |> Enum.map(fn(id) ->
    %{
      room_id: room_id,
      clinician_id: id,
      inserted_at: DateTime.utc_now(),
      updated_at: DateTime.utc_now()
    }
    end)
  end
end
