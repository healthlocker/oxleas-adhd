defmodule OxleasAdhd.ClinicianQuery do
  import Ecto.Query

  def get_by_user_id(struct, user_id) do
    from c in struct,
    where: c.caring_id == ^user_id
  end

  def get_patients_for_staff(struct, staff_id) do
    from c in struct,
    where: c.clinician_id == ^staff_id,
    select: c.caring_id
  end
end
