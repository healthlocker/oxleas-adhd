defmodule OxleasAdhd.UserQuery do
  import Ecto.Query

  def get_by_user_type(struct, user_type) do
    from u in struct,
    where: u.role == ^user_type
  end

  def get_user_by_details(struct, map) do
    %{"su_dob" => su_dob, "su_first_name" => su_first_name, "su_last_name" => su_last_name} = map
    from u in struct,
    where: u.dob == ^su_dob and u.first_name == ^su_first_name and u.last_name == ^su_last_name
  end
end
