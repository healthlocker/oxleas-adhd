defmodule Healthlocker.OxleasAdhd.CreateRoomTest do
  use Healthlocker.ModelCase, async: true
  alias Healthlocker.{User, Repo, ClinicianRooms, OxleasAdhd.CreateRoom}

  describe "success paths for connecting as slam su" do
    setup %{} do
      user = %User{
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

      multi = CreateRoom.connect_clinicians_and_create_rooms(
        user,
        [1235],
        [%{caring_id: 1234, clinician_id: 1235}]
      )

      {:ok, result} = Repo.transaction(multi)

      {:ok, result: result, multi: multi}
    end

    test "dry connect slam run", %{multi: multi} do
      assert [insert_clinicians: {:insert_all, _, _clinicians, []},
              room: {:insert, _, []},
              user_room: {:run, _},
              clinician_room: {:run, _}] = Ecto.Multi.to_list(multi)
    end

    test "insert_clinicians in multi contains number of clinicians inserted", %{result: result} do
      # this should be 1 since only a single clinician is inserted
      assert result.insert_clinicians == {1, nil}
    end

    test "room in multi contains correct room name", %{result: result} do
      assert result.room.name == "service-user-care-team:1234"
    end

    test "user room in multi contains room_id and user_id", %{result: result} do
      assert result.user_room.room_id == result.room.id
      assert result.user_room.user_id == 1234
    end

    test "clinician room in multi inserts_all successfully", %{result: result} do
      assert result.clinician_room == 1
      clinician_room = Repo.get_by(ClinicianRooms, clinician_id: 1235)
      assert clinician_room
      assert clinician_room.room_id == result.room.id
    end
  end
end
