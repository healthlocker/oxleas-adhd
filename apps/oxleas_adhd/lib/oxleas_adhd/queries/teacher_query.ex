defmodule OxleasAdhd.TeacherQuery do
  import Ecto.Query

  def get_teachers_for_service_user(struct, user_id) do
    from c in struct,
    where: c.caring_id == ^user_id
  end

end
