defmodule OxleasAdhd.ClinicianQuery do
  import Ecto.Query

  def get_by_user_id(struct, user_id) do
    from c in struct,
    where: c.caring_id == ^user_id
  end
end