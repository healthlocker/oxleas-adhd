defmodule App.Slam.DisconnectSlam do
  alias Ecto.Multi
  import Ecto.Query
  alias App.{User, Repo, UserRoom, ClinicianRooms, Message, Room}

  def disconnect_su(user) do
    Multi.new
    |> Multi.update(:user, User.disconnect_changeset(user))
    |> Multi.run(:user_room, &delete_user_room/1)
    |> Multi.run(:clinician_room, &delete_clinician_room/1)
    |> Multi.run(:messages, &delete_messages/1)
    |> Multi.run(:room, &delete_room/1)
  end

  def delete_user_room(multi) do
    user_room = Repo.get_by!(UserRoom, user_id: multi.user.id)
    case Repo.delete(user_room) do
      {:ok, user_room} ->
        {:ok, user_room}
      {:error, changeset} ->
        {:error, changeset, "Error deleting user_room"}
    end
  end

  def delete_clinician_room(multi) do
    query = from cr in ClinicianRooms, where: cr.room_id == ^multi.user_room.room_id
    case Repo.delete_all(query) do
      {n, nil} ->
        {:ok, n}
      _err ->
        {:error, "Error deleting clinician_room"}
    end
  end

  def delete_messages(multi) do
    query = from m in Message, where: m.room_id == ^multi.user_room.room_id
    case Repo.delete_all(query) do
      {n, nil} ->
        {:ok, n}
      _err ->
        {:error, "Error deleting messages"}
    end
  end

  def delete_room(multi) do
    room = Repo.get!(Room, multi.user_room.room_id)
    case Repo.delete(room) do
      {:ok, room} ->
        {:ok, room}
      {:error, changeset} ->
        {:error, changeset, "Error deleting room"}
    end
  end
end
