defmodule OxleasAdhd.MessageQuery do
  import Ecto.Query

  def has_unread_messages(struct, room_id) do
    from m in struct,
    where: m.room_id == ^room_id
    and m.unread == true
  end

end
