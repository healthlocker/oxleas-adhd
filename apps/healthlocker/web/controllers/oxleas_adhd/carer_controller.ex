defmodule Healthlocker.OxleasAdhd.CarerController do
  use Healthlocker.Web, :controller
  alias Healthlocker.{User, Carer}
  alias OxleasAdhd.UserQuery

  def new(conn, %{"user_id" => user_id}) do
    carer = Repo.get(User, user_id)
    conn
    |> render("new.html", carer: carer)
  end

  def submit_SU_details(conn, %{"su_info" => su_info, "user_id" => user_id}) do
    query = UserQuery.get_user_by_details(User, su_info)
    carer = Repo.get(User, user_id)
    service_user = Repo.one(query)

    case service_user do
      nil ->
        conn
        |> put_flash(:error, "could not find service user")
        |> redirect(to: oxleas_adhd_user_carer_path(conn, :new, carer))
      _ ->
        conn
        |> render("confirm.html", carer: carer, service_user: service_user)
    end
  end

  def confirm_SU_details(conn, %{"su_info" => su_info, "user_id" => carer_id}) do
    %{"service_user_id" => service_user_id} = su_info
    changeset = Carer.changeset(%Carer{carer_id: String.to_integer(carer_id), caring_id: String.to_integer(service_user_id)})
    carer = Repo.get(User, carer_id)
    service_user = Repo.get(User, service_user_id)
    case Repo.insert(changeset) do
      {:ok, _connect} ->
        conn
        |> put_flash(:info, "Carer connected to Service user")
        |> redirect(to: page_path(conn, :index))
      {:error, _error} ->
        conn
        |> put_flash(:error, "Carer could not connect")
        |> render("confirm.html", carer: carer, service_user: service_user)
    end
  end
end
