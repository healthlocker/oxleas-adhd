defmodule Healthlocker.OxleasAdhd.CaseloadControllerTest do
  use Healthlocker.ConnCase

  alias Healthlocker.{User}

  describe "current_user is assigned in the session with role clinician" do
    setup do
      %User{
        id: 123457,
        first_name: "Robert",
        last_name: "MacMurray",
        email: "robert_macmurray@nhs.co.uk",
        password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
        security_question: "Question?",
        security_answer: "Answer",
        role: "clinician",
      } |> Repo.insert

      {:ok, conn: build_conn() |> assign(:current_user, Repo.get(User, 123457)) }
    end

    test "GET /caseload", %{conn: conn} do
      conn = get conn, caseload_path(conn, :index)
      assert html_response(conn, 200) =~ "Caseload"
    end
  end
end
