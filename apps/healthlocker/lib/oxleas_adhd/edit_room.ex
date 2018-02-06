defmodule Healthlocker.OxleasAdhd.EditRoom do
  alias Ecto.Multi
  alias Healthlocker.{Repo, Clinician, Teacher, ClinicianRooms, Room}
  import Ecto.Query

  def connect_clinicians_and_update_rooms(room, clinician_ids, clinicians, query) do
    Multi.new
    |> Multi.delete_all(:delete_clinicians, query)
    |> Multi.delete_all(:delete_clin_rooms, (from cr in ClinicianRooms, where: cr.room_id == ^room.id))
    |> Multi.insert_all(:insert_clinicians, Clinician, clinicians)
    |> Multi.run(:clinician_room, &add_clinicians_to_room(&1, clinician_ids, room))
  end

  def connect_teachers_and_update_rooms(service_user, teacher_ids, teachers, query) do
    Multi.new
    |> Multi.delete_all(:delete_teachers, query)
    |> Multi.insert_all(:insert_teachers, Teacher, teachers)
    |> Multi.insert_all(:teacher_rooms, Room, add_teachers_room(service_user.id, teacher_ids))
  end

  defp add_teachers_room(user_id, teacher_ids) do
    existing_rooms = Repo.all(from r in Room, where: ilike(r.name, ^"teacher-care-team:#{user_id}%"))
                   |> Enum.map(fn(room) ->
                     room.name
                   end)
    teacher_room_names = Enum.map(teacher_ids, fn(teacher_id) ->
      "teacher-care-team:#{user_id}:#{teacher_id}"
    end)
    |> Enum.filter(fn(room) ->
      !Enum.member?(existing_rooms, room)
    end)
    |> Enum.map(fn(room) ->
      %{
         name: room,
         inserted_at: Timex.now(),
         updated_at: Timex.now()
       }
    end)
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
