defmodule Healthlocker.RoomChannel do
  use Healthlocker.Web, :channel
  alias Healthlocker.Presence

  alias Healthlocker.{Message, MessageView, Room, User}

  def join("room:" <> room_id, _params, socket) do
    room = Repo.get!(Room, room_id)
    Repo.all from m in Message,
      where: m.room_id == ^room.id,
      order_by: [asc: :inserted_at, asc: :id],
      preload: [:user]

    send(self(), :after_join)
    {:ok, nil, assign(socket, :room, room)}
  end

  def is_clinician_in_socket?(users_in_socket) do
    users_in_socket
    |> Enum.map(fn {id, map} ->
      map.metas |> List.first |> Map.get(:role)
    end)
    |> Enum.member?("clinician")
  end

  def handle_in("msg:new", params, socket) do
    current_user = Repo.get(User, socket.assigns.user_id)

    changeset =
      socket.assigns.room
      |> build_assoc(:messages, user_id: socket.assigns.user_id)
      |> Message.changeset(params)

    connected_users = Presence.list(socket)

    changeset =
      if Enum.member?(["service_user", "teacher", "carer"], current_user.role) && !is_clinician_in_socket?(connected_users) do
        Ecto.Changeset.put_change(changeset, :unread, true)
      else
        Ecto.Changeset.put_change(changeset, :unread, false)
    end

    case Repo.insert(changeset) do
      {:ok, message} ->
        broadcast_message(socket, message)
        {:reply, :ok, socket}
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", Presence.list(socket)
    {:ok, _} = Presence.track(socket, socket.assigns.user_id, %{
      role: Repo.get!(User, socket.assigns.user_id).role
      })
    {:noreply, socket}
  end

  defp broadcast_message(socket, message) do
    message = Repo.preload(message, :user)
    connected_users = Presence.list(socket)
    rendered_message = Phoenix.View.render_to_string(MessageView, "_message.html", message: message, current_user_id: nil)
    broadcast!(socket, "msg:created", %{template: rendered_message, id: message.id, message_user_id: socket.assigns.user_id})
  end
end
