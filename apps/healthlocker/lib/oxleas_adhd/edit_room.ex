defmodule Healthlocker.OxleasAdhd.EditRoom do
  alias Ecto.Multi
  alias Healthlocker.{Repo, Clinician, ClinicianRooms}
  import Ecto.Query

  def connect_clinicians_and_update_rooms(room, clinician_ids, clinicians, query) do
    Multi.new
    |> Multi.delete_all(:delete_clinicians, query)
    |> Multi.delete_all(:delete_clin_rooms, (from cr in ClinicianRooms, where: cr.room_id == ^room.id))
    |> Multi.insert_all(:insert_clinicians, Clinician, clinicians)
    |> Multi.run(:clinician_room, &add_clinicians_to_room(&1, clinician_ids, room))
  end

  defp add_clinicians_to_room(_multi, clinician_ids, room) do
    clinicians = clinician_ids |> make_clinicians(room.id)

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
