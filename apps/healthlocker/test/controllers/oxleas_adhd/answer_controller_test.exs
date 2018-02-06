defmodule Healthlocker.OxleasAdhd.AnswerControllerTest do
  use Healthlocker.ConnCase
  alias Healthlocker.{Answer, User}

  @valid_attrs %{
    "sec1" => %{"1" => "", "2" => "", "3" => "", "4" => "", "5" => "", "6" => ""},
    "sec2" => %{"1" => "", "2" => "", "3" => ""},
    "sec3" => %{"1" => "", "2" => "", "3" => "", "4" => ""},
    "sec4" => %{"1" => "","10" => "","2" => "","3" => "","4" => "","5" => "","6" => "","7" => "","8" => "","9" => ""},
    "sec5" => %{"1" => "", "2" => "", "3" => "", "4" => "", "5" => ""},
    "sec6" => %{"1" => "", "2" => "", "3" => "", "4" => "", "5" => ""},
    "sec7" => %{"1" => "", "2" => "", "3" => "", "4" => ""}
  }

  def make_ans(list, section, id, su_id, teacher_id) do
    Enum.map(list, fn i ->
      %Answer{
        section: section,
        answer: "test",
        question: Integer.to_string(1+i),
        id: id+i,
        su_id: su_id,
        last_updated_by_id: teacher_id
      } |> Repo.insert
    end)
  end

  describe "No user logged in" do
    test "GET users/1/school-feedback/new gets redirected", %{conn: conn} do
      conn = get conn, user_answer_path(conn, :new, %User{id: 1})
      assert html_response(conn, 302)
    end
  end
  #
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

      make_ans(0..5, "sec1", 12345, 1234, 3456)
      make_ans(0..2, "sec2", 2345, 1234, 3456)
      make_ans(0..3, "sec3", 3456, 1234, 3456)
      make_ans(0..9, "sec4", 234567, 1234, 3456)
      make_ans(0..4, "sec5", 1234595, 1234, 3456)
      make_ans(0..4, "sec6", 9345, 1234, 3456)
      make_ans(0..3, "sec7", 4115, 1234, 3456)

      answer = Repo.get(Answer, 12345)

      {:ok, su: su, teacher: teacher, answer: answer,
        conn: build_conn() |> assign(:current_user, su)}
    end

    test "GET show", %{conn: conn, answer: answer} do
      conn = get conn, user_answer_path(conn, :show, conn.assigns.current_user, answer)
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

      make_ans(0..5, "sec1", 12345, 1234, 3456)
      make_ans(0..2, "sec2", 2345, 1234, 3456)
      make_ans(0..3, "sec3", 3456, 1234, 3456)
      make_ans(0..9, "sec4", 234567, 1234, 3456)
      make_ans(0..4, "sec5", 1234595, 1234, 3456)
      make_ans(0..4, "sec6", 9345, 1234, 3456)
      make_ans(0..3, "sec7", 4115, 1234, 3456)

      query = from a in Answer, where: a.su_id == 1234
      [answer | _]= Repo.all(query)

      {:ok, su: su, su2: su2, answer: answer,
        conn: build_conn() |> assign(:current_user, teacher)}
    end

    test "GET users/1234/school-feedback/new", %{conn: conn, su2: su2} do
      conn = get conn, user_answer_path(conn, :new, su2)
      assert html_response(conn, 200) =~ "feedback"
    end

    test "get edit", %{conn: conn, su: su, answer: answer} do
      conn = get conn, user_answer_path(conn, :new, su)
      assert redirected_to(conn) == user_answer_path(conn, :edit, su, answer)
    end

    test "POST create is successful", %{conn: conn, su2: su2} do
      conn = post conn, user_answer_path(conn, :create, su2), data: @valid_attrs
      assert redirected_to(conn, 302) =~ caseload_user_path(conn, :show, su2, section: "details")
    end

    test "PUT update is successful with valid attrs", %{conn: conn, su: su, answer: answer} do
      conn = put conn, user_answer_path(conn, :update, su, answer), data: @valid_attrs
      assert redirected_to(conn, 302) =~ caseload_user_path(conn, :show, su, section: "details")
    end
  end
end
