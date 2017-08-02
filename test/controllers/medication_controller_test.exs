defmodule OxleasAdhd.MedicationControllerTest do
  use OxleasAdhd.ConnCase
  alias OxleasAdhd.{User, Medication}

  @valid_attrs %{
    name: "XYZ",
    dosage: "1mg",
    frequency: "twice",
    other_medicine: "none",
    allergies: "none",
    past_medication: "none",
    user_id: 1234
  }

  @invalid_attrs %{
    name: "",
    dosage: "",
    frequency: "",
    other_medicine: "",
    allergies: "",
    past_medication: "",
    user_id: 4321
  }

  setup %{} do
    user = %User{
      id: 1234,
      email: "email@example.com"
    } |> Repo.insert!

    user2 = %User{
      id: 4321,
      email: "user@example.com"
    } |> Repo.insert!

    medication = %Medication{
      id: 4321,
      name: "ABC",
      dosage: "1mg",
      frequency: "twice",
      other_medicine: "none",
      allergies: "none",
      past_medication: "none",
      user_id: 4321
    } |> Repo.insert!

    {:ok, user: user, user2: user2, medication: medication}
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

  test "GET edit", %{conn: conn, user2: user, medication: medication} do
    conn = get conn, user_medication_path(conn, :edit, user, medication)
    assert html_response(conn, 200) =~ "Edit Medication"
  end

  test "PUT update is successful with valid attrs", %{conn: conn, user2: user, medication: medication} do
    conn = put conn, user_medication_path(conn, :update, user, medication), medication: @valid_attrs
    assert redirected_to(conn, 302) =~ user_path(conn, :index)
  end

  test "PUT update is unsuccessful with invalid attrs", %{conn: conn, user2: user, medication: medication} do
    conn = put conn, user_medication_path(conn, :update, user, medication), medication: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Medication"
    assert get_flash(conn, :error) == "Error editing medication"
  end
end
