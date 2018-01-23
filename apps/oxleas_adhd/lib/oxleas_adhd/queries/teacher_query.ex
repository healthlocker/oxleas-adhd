defmodule OxleasAdhd.TeacherQuery do
  import Ecto.Query

  def get_teachers_for_service_user(struct, user_id) do
    from c in struct,
    where: c.caring_id == ^user_id
  end

  def get_patients_for_teacher(struct, teacher_id) do
    from c in struct,
    where: c.teacher_id == ^teacher_id,
    select: c.caring_id
  end


end
