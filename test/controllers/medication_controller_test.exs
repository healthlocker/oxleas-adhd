defmodule OxleasAdhd.MedicationControllerTest do
  use OxleasAdhd.ConnCase
  alias OxleasAdhd.User

  @valid_attrs %{
    name: "XYZ",
    dosage: "1mg",
    frequency: "twice",
    other_medicine: "none",
    allergies: "none",
    past_medication: "none",
    user_id: 1234
  }

  @invalid_attrs %{}

  setup %{} do
    user = %User{
      id: 1234,
      email: "email@example.com"
    } |> Repo.insert!

    {:ok, user: user}
  end

  test "GET new", %{conn: conn, user: user} do
    conn = get conn, user_medication_path(conn, :new, user)
    assert html_response(conn, 200) =~ "Medication"
  end

  test "POST create is successful with valid attrs", %{conn: conn, user: user} do
    conn = post conn, user_medication_path(conn, :create, user), medication: @valid_attrs
    assert redirected_to(conn, 302) =~ user_path(conn, :index)
  end

  test "POST create is unsuccessful with invalid attrs", %{conn: conn, user: user} do
    conn = post conn, user_medication_path(conn, :create, user), medication: @invalid_attrs
    assert html_response(conn, 200) =~ "Medication"
    assert get_flash(conn, :error) == "Error adding medication"
  end
end
