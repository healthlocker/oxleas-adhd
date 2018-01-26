defmodule Healthlocker.Plugs.FindRoom do
  @moduledoc """
  A small plug to find the room for a service user.
  """

  import Plug.Conn
  alias Healthlocker.Repo

  def find_room(conn, _options) do
    if conn.assigns[:current_user] do
      rooms = Repo.all Ecto.assoc(conn.assigns[:current_user], :rooms)

      room = case conn.assigns[:current_user].role do
        "service_user" ->
          find_room_by_user_type(rooms, "service-user-care-team")
        "carer" ->
          find_room_by_user_type(rooms, "carer-care-team")
        _ ->
          nil
      end

      conn
      |> assign(:room, room)
    else
      conn
      |> assign(:room, nil)
    end
  end

  defp find_room_by_user_type(rooms, user_type) do
    Enum.find(rooms, fn(r) ->
      List.first(String.split(r.name, ":")) == user_type
    end)
  end
end
