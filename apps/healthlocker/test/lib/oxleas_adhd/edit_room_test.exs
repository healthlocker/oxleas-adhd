defmodule Healthlocker.OxleasAdhd.EditRoomTest do
  use Healthlocker.ModelCase, async: true
  alias Healthlocker.{User, Room, Repo, Clinician, ClinicianRooms, OxleasAdhd.EditRoom}
  alias OxleasAdhd.ClinicianQuery

  describe "success paths for connecting as slam su" do
    setup %{} do
      %User{
        id: 1234,
        email: "service_user@mail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer"
      } |> Repo.insert!

      %User{
        id: 1235,
        email: "clinician@mail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer"
      } |> Repo.insert!

      room = %Room{
        id: 401,
        name: "service-user-care-team:1234"
      } |> Repo.insert!

      query = Clinician |> ClinicianQuery.get_staff_for_service_user(1234)

      multi = EditRoom.connect_clinicians_and_update_rooms(
        room,
        [1235],
        [%{caring_id: 1234, clinician_id: 1235}],
        query
      )

      {:ok, result} = Repo.transaction(multi)

      {:ok, result: result, multi: multi}
    end

    test "dry connect slam run", %{multi: multi} do
      assert [delete_clinicians: {:delete_all, _, []},
              delete_clin_rooms: {:delete_all, _, []},
              insert_clinicians: {:insert_all, _, _clinicians, []},
              clinician_room: {:run, _}] = Ecto.Multi.to_list(multi)
    end

    test "delete_clinicians in multi contains number of clinicians deleted", %{result: result} do
      # this should be 0 for the test as no clinicians are there to remove
      assert result.delete_clinicians == {0, nil}
    end

    test "insert_clinicians in multi contains number of clinicians inserted", %{result: result} do
      # this should be 1 since only a single clinician is inserted
      assert result.insert_clinicians == {1, nil}
    end

    test "clinician room in multi inserts_all successfully", %{result: result} do
      assert result.clinician_room == 1
      clinician_room = Repo.get_by(ClinicianRooms, clinician_id: 1235)
      assert clinician_room
      assert clinician_room.room_id == 401
    end
  end
end
