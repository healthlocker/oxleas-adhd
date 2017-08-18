defmodule Healthlocker.Caseload.UserControllerTest do
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
        slam_id: 201
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

      %Room{
        id: 1,
        name: "service-user-care-team:123456"
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
  end
end
