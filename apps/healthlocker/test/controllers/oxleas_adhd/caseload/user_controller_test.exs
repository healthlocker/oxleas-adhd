defmodule Healthlocker.OxleasAdhd.Caseload.UserControllerTest do
  use Healthlocker.ConnCase

  alias Healthlocker.{User, Room, UserRoom}

  describe "clinician current_user is assigned" do
    setup do
      %User{
        id: 123_456,
        first_name: "My",
        last_name: "Name",
        email: "abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
        role: "service_user"
      } |> Repo.insert

      %User{
        id: 123_457,
        first_name: "Robert",
        last_name: "MacMurray",
        email: "robert_macmurray@nhs.co.uk",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
        role: "clinician"
      } |> Repo.insert

      %User{
        id: 123_458,
        first_name: "Teacher",
        last_name: "Teacher",
        email: "teacher@nhs.co.uk",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
        role: "teacher"
      } |> Repo.insert

      %Room{
        id: 1,
        name: "service-user-care-team:123456"
      } |> Repo.insert

      %Room{
        id: 2,
        name: "teacher-care-team:123458:123456"
      } |> Repo.insert

      %UserRoom{
        user_id: 123456,
        room_id: 1
      } |> Repo.insert

      {:ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 123_457)) }
    end

    test "GET /caseload/users/:id?section=details for details", %{conn: conn} do
      user = Repo.get(User, 123_456)
      conn = get conn, caseload_user_path(conn, :show, user, section: "details")
      assert html_response(conn, 200) =~ "Date of Birth"
    end

    test "GET /caseload/users/:id?section=interactions for interactions", %{conn: conn} do
      user = Repo.get(User, 123_456)
      conn = get conn, caseload_user_path(conn, :show, user, section: "interactions")
      assert html_response(conn, 200) =~ "Coping Strategies"
    end

    test "caseload/users/:id?section=tracking&date=2017-05-18&shift=next", %{conn: conn} do
      user = Repo.get(User, 123_456)
      conn = get conn, caseload_user_path(conn, :show, user, section: "tracking", date: "2017-05-18", shift: "next")
      assert html_response(conn, 200) =~ "Tracking overview"
    end

    test "clinician clicking to chat to a service user's teacher, /caseload/users/:id/rooms/:room_id?patient=:su_id", %{conn: conn} do
      user = Repo.get(User, 123_456)
      teacher = Repo.get(User, 123_458)
      room = Repo.get(Room, 2)
      conn = get conn, caseload_user_room_path(conn, :show, teacher, room, patient: user)
      assert html_response(conn, 200) =~ "teacher of"
    end
  end

  describe "teacher current_user is assigned" do
    setup do
      %User{
        id: 345678,
        first_name: "My",
        last_name: "Name",
        email: "abc@gmail.com",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
        role: "service_user"
      } |> Repo.insert

      %User{
        id: 345679,
        first_name: "Robert",
        last_name: "MacMurray",
        email: "robert_macmurray@nhs.co.uk",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
        role: "clinician"
      } |> Repo.insert

      %User{
        id: 345670,
        first_name: "Teacher",
        last_name: "Teacher",
        email: "teacher@nhs.co.uk",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
        role: "teacher"
      } |> Repo.insert

      %Room{
        id: 1,
        name: "service-user-care-team:345678"
      } |> Repo.insert

      %Room{
        id: 2,
        name: "teacher-care-team:345670:345678"
      } |> Repo.insert

      %UserRoom{
        user_id: 345678,
        room_id: 1
      } |> Repo.insert

      {:ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 345670)) }
    end

    test "caseload/users/:id/room/:idroom teacher", %{conn: conn} do
      service_user = Repo.get(User, 345678)
      teacher = Repo.get(User, 345670)
      room = Repo.get(Room, 2)
      conn = get conn, caseload_user_room_path(conn, :show, service_user, room )
      assert html_response(conn, 200) =~ "Write a message to My Name's care team."
    end
  end
end
