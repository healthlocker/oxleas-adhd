defmodule Healthlocker.OxleasAdhd.Caseload.RoomController do
  alias Healthlocker.{Message, Room, User, OxleasAdhd.ServiceUser}
  use Healthlocker.Web, :controller

  def show(conn, %{"id" => id, "user_id" => user_id}) do
    room = Repo.get((from r in Room, preload: [messages: :user]), id)

    messages =
      Repo.all from m in Message,
      where: m.room_id == ^room.id,
      order_by: [asc: :inserted_at, asc: :id],
      preload: [:user]

    user = Repo.get!(User, user_id)
    service_user = ServiceUser.for(user)

    conn
    |> assign(:service_user, service_user)
    |> assign(:room, room)
    |> assign(:messages, messages)
    |> assign(:user, user)
    |> assign(:current_user_id, conn.assigns.current_user.id)
    |> render("show.html")
  end
end
