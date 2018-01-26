defmodule Healthlocker.OxleasAdhd.SchoolFeedbackControllerTest do
  use Healthlocker.ConnCase
  alias Healthlocker.{SchoolFeedback, User}

  @valid_attrs %{
    p1q1: "1",
    user_id: 1234
  }

  @valid_attrs2 %{
    p1q1: "1",
    user_id: 2345
  }

  describe "No user logged in" do
    test "GET users/1/school-feedback/new gets redirected", %{conn: conn} do
      conn = get conn, user_about_me_path(conn, :new, %User{id: 1})
      assert html_response(conn, 302)
    end
  end

  describe "SU is assigned to the conn" do
    setup do
      {:ok, su} = %User{
        id: 1234,
        email: "service@email.com",
        role: "slam_user"
      } |> Repo.insert

      {:ok, teacher} = %User{
        id: 3456,
        email: "teacher@email.com",
        role: "teacher"
      } |> Repo.insert

      {:ok, feedback} = %SchoolFeedback{
        id: 9876,
        user_id: 1,
        last_updated_by: 3
      } |> Repo.insert

      {:ok, su: su, teacher: teacher, feedback: feedback,
        conn: build_conn() |> assign(:current_user, su)}
    end

    test "GET show", %{conn: conn, feedback: feedback} do
      conn = get conn, user_school_feedback_path(conn, :show, conn.assigns.current_user, feedback)
      assert html_response(conn, 200) =~ "School feedback"
    end

  end

  describe "Teacher is assigned to the conn" do
    setup do
      {:ok, su} = %User{
        id: 1234,
        email: "service@email.com",
        role: "slam_user"
      } |> Repo.insert

      {:ok, su2} = %User{
        id: 2345,
        email: "service2@email.com",
        role: "slam_user"
      } |> Repo.insert

      {:ok, teacher} = %User{
        id: 3456,
        email: "teacher@email.com",
        role: "teacher"
      } |> Repo.insert

      {:ok, feedback} = %SchoolFeedback{
        id: 9876,
        user_id: 2345,
        last_updated_by: 3456
      } |> Repo.insert


      {:ok, su: su, su2: su2, feedback: feedback,
        conn: build_conn() |> assign(:current_user, teacher)}
    end

    test "GET users/1/school-feedback/new", %{conn: conn, su: su} do
      conn = get conn, user_school_feedback_path(conn, :new, su)
      assert html_response(conn, 200) =~ "feedback"
    end

    test "get edit", %{conn: conn, su2: su2, feedback: feedback} do
      conn = get conn, user_school_feedback_path(conn, :new, su2)
      assert redirected_to(conn) == user_school_feedback_path(conn, :edit, su2, feedback)
    end

    test "POST create is successful", %{conn: conn, su: su} do
      conn = post conn, user_school_feedback_path(conn, :create, su), school_feedback: @valid_attrs
      assert redirected_to(conn, 302) =~ caseload_user_path(conn, :show, su, section: "details")
    end

    test "PUT update is successful with valid attrs", %{conn: conn, su2: su2, feedback: feedback} do
      conn = put conn, user_school_feedback_path(conn, :update, su2, feedback), school_feedback: @valid_attrs2
      assert redirected_to(conn, 302) =~ caseload_user_path(conn, :show, su2, section: "details")
    end
  end
end
