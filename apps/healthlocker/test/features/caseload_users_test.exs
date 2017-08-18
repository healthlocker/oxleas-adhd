defmodule Healthlocker.CaseloadUsersTest do
  use Healthlocker.FeatureCase
  alias Healthlocker.{Clinician, ClinicianRooms, Carer, Repo, Room, User, UserRoom}

  setup %{session: session} do
    Repo.insert!(%User{
      email: "robert_macmurray@nhs.co.uk",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      first_name: "Mary",
      last_name: "Clinician",
      phone_number: "07598 765 432",
      security_question: "Name of first boss?",
      security_answer: "Betty",
      data_access: true,
      role: "clinician",
      id: 1235
    })

    EctoFactory.insert(:user,
      email: "tony@dwyl.io",
      first_name: "Tony",
      last_name: "Daly",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      terms_conditions: true,
      privacy: true,
      data_access: true,
      role: "service_user",
      id: 12345
    )

    EctoFactory.insert(:user,
      email: "carer@dwyl.io",
      first_name: "Jimmy",
      last_name: "Smits",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      terms_conditions: true,
      privacy: true,
      data_access: true,
      role: "carer",
      id: 1234
    )

    %Carer{
      caring_id: 12345,
      carer_id: 1234
    } |> Repo.insert!

    %Clinician{
      caring_id: 12345,
      clinician_id: 1235
    } |> Repo.insert!

    %Room{
      id: 1,
      name: "carer-care-team:1234"
    } |> Repo.insert

    %UserRoom{
      id: 1,
      user_id: 1234,
      room_id: 1
    } |> Repo.insert

    %ClinicianRooms{
      clinician_id: 1235,
      room_id: 1
    } |> Repo.insert

    %Room{
      id: 2,
      name: "service-user-care-team:12345"
    } |> Repo.insert

    %UserRoom{
      id: 2,
      user_id: 12345,
      room_id: 2
    } |> Repo.insert

    %ClinicianRooms{
      clinician_id: 1235,
      room_id: 2
    } |> Repo.insert

    session |> log_in("robert_macmurray@nhs.co.uk")
    {:ok, %{session: session}}
  end

  test "shows service users", %{session: session} do
    session
    |> resize_window(768, 1024)
    |> click(Query.link("Caseload"))
    |> take_screenshot

    assert session |> has_text?("Tony Daly")
  end

  test "shows carers", %{session: session} do
    session
    |> resize_window(768, 1024)
    |> click(Query.link("Caseload"))
    |> take_screenshot

    assert session |> has_text?("Jimmy Smits (friend/family/carer)")
  end

  test "view service user", %{session: session} do
    session
    |> resize_window(768, 1024)
    |> click(Query.link("Caseload"))
    |> click(Query.link("Tony Daly"))
    |> click(Query.link("Details and Meds"))
    |> take_screenshot

    assert session |> has_text?("Phone number")
    assert session |> has_text?("tony@dwyl.io")
  end

  test "service user send message", %{session: session} do
    session
    |> resize_window(768, 1024)
    |> click(Query.link("Caseload"))
    |> click(Query.link("Tony Daly"))
    |> click(Query.link("Messages"))
  end

  test "view carer", %{session: session} do
    session
    |> resize_window(768, 1024)
    |> click(Query.link("Caseload"))
    |> click(Query.link("Jimmy Smits (friend/family/carer)"))
    |> click(Query.link("Details and Meds"))
    |> take_screenshot

    assert session |> has_text?("Jimmy Smits")
  end

  test "view tracking overview", %{session: session} do
    session
    |> resize_window(768, 1024)
    |> click(Query.link("Caseload"))
    |> click(Query.link("Tony Daly"))
    |> click(Query.link("Tracking"))
    |> take_screenshot

    assert has_text?(session, "Tracking overview")
  end

  test "view goals and strategies", %{session: session} do
    session
    |> resize_window(768, 1024)
    |> click(Query.link("Caseload"))
    |> click(Query.link("Tony Daly"))
    |> click(Query.link("Goals and Strategies"))
    |> take_screenshot

    assert has_text?(session, "No goals yet created")
  end

  test "view list of carers", %{session: session} do
    session
    |> resize_window(768, 1024) # The caseload link doesn't show on mobile.
    |> click(Query.link("Caseload"))

    assert has_text?(session, "Jimmy Smits (friend/family/carer)")
  end

  test "message carer", %{session: session} do
    session
    |> resize_window(768, 1024) # The caseload link doesn't show on mobile.
    |> click(Query.link("Caseload"))
    |> click(Query.link("Jimmy Smits (friend/family/carer)"))
    |> fill_in(Query.css("#message-input"), with: "Hello there")
    |> send_keys([:enter])
    |> has_text?("Hello there")
  end

  test "message service user", %{session: session} do
    session
    |> resize_window(768, 1024) # The caseload link doesn't show on mobile.
    |> click(Query.link("Caseload"))
    |> click(Query.link("Tony Daly"))
    |> click(Query.link("Messages"))
    |> fill_in(Query.css("#message-input"), with: "Sand")
    |> send_keys([:enter])
    |> has_text?("Sand")
  end
end
