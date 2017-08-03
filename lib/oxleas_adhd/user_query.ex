defmodule OxleasAdhd.UserQuery do
  import Ecto.Query

  def get_by_user_type(struct, user_type) do
    from u in struct,
    where: u.role == "clinician"
  end
end
