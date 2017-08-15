defmodule OxleasAdhd.ServiceUser do
  alias OxleasAdhd.Repo

  @moduledoc """
  If the user has role of service_user, then the same user is returned.
  However, if the user has a role of carer, then their service user is the user they care for.
  """
  def for(user) do
    if user.role == "service_user" do
      user
    else
      user = user |> Repo.preload(:caring)
      [service_user | _] = user.caring
      service_user
    end
  end
end
