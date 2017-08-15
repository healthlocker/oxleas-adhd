defmodule OxleasAdhd.MedicationQuery do
  import Ecto.Query

  def get_medication_for_user(struct, user_id, id) do
    from m in struct,
    where: m.id == ^id and m.user_id == ^user_id
  end
end
