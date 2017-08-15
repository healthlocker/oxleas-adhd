defmodule Healthlocker.OxleasAdhd.CreateCarerRoomTest do
  use Healthlocker.ModelCase, async: true
  alias Healthlocker.{User, OxleasAdhd.CreateCarerRoom, ClinicianRooms, Room}

  describe "success paths for connecting carer" do
    setup %{} do
      user = %User{
        id: 1234,
        first_name: "Lisa",
        last_name: "Sandoval",
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

      carer = %User{
        id: 1236,
        email: "carer@mail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer"
      } |> Repo.insert!

      multi = CreateCarerRoom.connect_carers_and_create_rooms(carer, user, [1235])
      {:ok, result} = Repo.transaction(multi)

      {:ok, result: result, multi: multi}
    end

    test "dry carer connection run", %{multi: multi} do
      assert [carer: {:insert, _, []},
              room: {:insert, _, []},
              carer_room: {:run, _},
              clinician_room: {:run, _}] = Ecto.Multi.to_list(multi)
    end

    test "carer in multi result contains carer_id and caring_id", %{result: result} do
      assert result.carer.carer_id == 1236
      assert result.carer.caring_id == 1234
    end

    test "room in multi result contains room name for carer", %{result: result} do
      assert result.room.name == "carer-care-team:1236"
    end

    test "carer_room in multi result contains room_id and user_id", %{result: result} do
      assert result.carer_room.room_id == result.room.id
      assert result.carer_room.user_id == 1236
    end

    test "clinician_room in multi result inserts_all successfully", %{result: result} do
      # clinician room uses insert_all, so returns number of clinicians inserted
      assert result.clinician_room == 1
      clinician_room = Repo.get_by(ClinicianRooms, clinician_id: 1235)
      assert clinician_room
      assert clinician_room.room_id == result.room.id
    end
  end

  describe "failure for connecting carer" do
    setup %{} do
      user = %User{
        id: 1234,
        first_name: "Lisa",
        last_name: "Sandoval",
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

      carer = %User{
        id: 1236,
        email: "carer@mail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer"
      } |> Repo.insert!

      multi = CreateCarerRoom.connect_carers_and_create_rooms(carer, user, [1235])

      {:ok, multi: multi}
    end


    test "carer response on error", %{multi: multi} do
      Repo.transaction(multi)
      # running the transaction twice causes an error because the carer already exists
      assert {:error, type, result, _} = Repo.transaction(multi)
      assert type == :carer
      assert result.errors
    end

    test "room response on error", %{multi: multi} do
      %Room{
        id: 501,
        name: "carer-care-team:1236"
      } |> Repo.insert!
      assert {:error, type, result, _} = Repo.transaction(multi)
      assert type == :room
      assert result.errors
    end
  end
end
