defmodule Healthlocker.OxleasAdhd.CaseloadView do
  use Healthlocker.Web, :view

  def room_for(user, type) do
    rooms = user.rooms
    case type do
      "teacher" ->
        find_room(rooms, "teacher-care-team")
      "service_user" ->
        find_room(rooms, "service-user-care-team")
      "carer" ->
        IO.inspect "&&&&&&&&&&&&&&&&&&&&"
        r = find_room(rooms, "carer-care-team")
        IO.inspect r
        IO.inspect "&&&&&&&&&&&&&&&&&&&&"
        r
    end
  end

  defp find_room(rooms, type) do
    Enum.find(rooms, fn(r) ->
      List.first(String.split(r.name, ":")) == type
    end)
  end
end
