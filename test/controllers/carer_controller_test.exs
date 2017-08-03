defmodule OxleasAdhd.CarerControllerTest do
  use OxleasAdhd.ConnCase
  alias OxleasAdhd.{User, Carer}

  setup %{} do
    %User{
      id: 1,
      first_name: "test",
      last_name: "test",
      relationship: "parent",
      email: "carer@example.com",
      password: "password"
    } |> Repo.insert!

    %User{
      id: 2,
      first_name: "test",
      last_name: "test",
      dob: "01/01/2000",
      email: "su@example.com",
      password: "password"
    } |> Repo.insert!

    { :ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 1)) }
  end

  @valid_attrs %{
    su_dob: "01/01/2000",
    su_first_name: "test",
    su_last_name: "test"
  }

  @invalid_attrs %{
    su_dob: "01/01/2000",
    su_first_name: "wrong",
    su_last_name: "name"
  }

  describe "endpoints in carer controller work as expected" do

    test "get new html at when a carer has been created", %{conn: conn} do
      conn = get conn, "/super-admin/users/1/carer-connection/new"
      assert html_response(conn, 200)
    end

    test "post with correct service user info loads confirm html", %{conn: conn} do
      carer = Repo.get(User, 1)
      conn = post conn, user_carer_path(conn, :submit_SU_details, carer), su_info: @valid_attrs
      assert html_response(conn, 200)
    end

    test "post to submit_SU_details with incorrect params gets redirected", %{conn: conn} do
      carer = Repo.get(User, 1)
      conn = post conn, user_carer_path(conn, :submit_SU_details, carer), su_info: @invalid_attrs
      assert html_response(conn, 302)
    end

    test "post to confirm_SU_details with correct service user info stores data in carers table", %{conn: conn} do
      carer = Repo.get(User, 1)
      conn = post conn, user_carer_path(conn, :confirm_SU_details, carer), su_info: %{"service_user_id" => "2"}
      carer_connection =
        Repo.all(from c in Carer, where: c.carer_id == 1)
        |> Enum.at(0)
      assert html_response(conn, 302)
      assert carer_connection.caring_id == 2
    end

    test "post to submit_SU_details incorrect with params gets redirected", %{conn: conn} do
      carer = Repo.get(User, 1)
      conn = post conn, user_carer_path(conn, :confirm_SU_details, carer), su_info: %{"service_user_id" => "9999"}
      assert html_response(conn, 200)
    end
  end
end
