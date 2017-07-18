defmodule App.CaseloadView do
  use App.Web, :view

  def room_for(user) do
    [room| _] = user.rooms
    room
  end
end
