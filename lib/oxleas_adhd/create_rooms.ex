defmodule OxleasAdhd.CreateRooms do
  alias Ecto.Multi
  alias OxleasAdhd.{Room, UserRoom, Repo, Clinician, ClinicianRooms, ClinicianQuery}

  def connect_clinicians_and_create_rooms(user, clinician_ids, clinicians, query) do
    Multi.new
    |> Multi.delete_all(:delete_clinicians, query)
    |> Multi.insert_all(:insert_clinicians, Clinician, clinicians)
    |> Multi.insert(:room, Room.changeset(%Room{}, %{
      name: "service-user-care-team:" <> Integer.to_string(user.id)
    }))
    |> Multi.run(:user_room, &add_su_to_room(&1, user))
    |> Multi.run(:clinician_room, &add_clinicians_to_room(&1, user, clinician_ids))
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

  defp add_clinicians_to_room(multi, user, clinician_ids) do
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
