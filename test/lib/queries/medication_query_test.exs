defmodule MedicationQueryTest do
  use OxleasAdhd.ConnCase
  alias OxleasAdhd.{User, Medication, MedicationQuery}

  setup %{} do
    %User{
      id: 1234,
      email: "user@example.com"
    } |> Repo.insert!

    %User{
      id: 12345,
      email: "other_user@example.com"
    }

    %Medication{
      id: 4321,
      name: "ABC",
      dosage: "1mg",
      frequency: "twice",
      other_medicine: "none",
      allergies: "none",
      past_medication: "none",
      user_id: 1234
    } |> Repo.insert!

    :ok
  end

  test "get medication for user returns med when user and med exist" do
    actual = MedicationQuery.get_medication_for_user(Medication, 1234, 4321)
              |> Repo.one
    expected = Repo.get!(Medication, 4321)
    assert actual == expected
  end

  test "get_medication_for_user returns nil when med doesn't exist" do
    actual = MedicationQuery.get_medication_for_user(Medication, 12345, 9876)
              |> Repo.one
    assert actual == nil
  end
end
