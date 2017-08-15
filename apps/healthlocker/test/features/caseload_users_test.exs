defmodule Healthlocker.CaseloadUsersTest do
  use Healthlocker.FeatureCase
  alias Healthlocker.{Carer, Repo, User}

  setup %{session: session} do
    service_user_1 = EctoFactory.insert(:user,
      email: "tony@dwyl.io",
      first_name: "Tony",
      last_name: "Daly",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      terms_conditions: true,
      privacy: true,
      data_access: true,
      slam_id: 202
    )

    service_user_2 = EctoFactory.insert(:user,
      email: "kat@dwyl.io",
      first_name: "Kat",
      last_name: "Bow",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      terms_conditions: true,
      privacy: true,
      data_access: true,
      slam_id: 203
    )

    carer = EctoFactory.insert(:user,
      email: "carer@dwyl.io",
      first_name: "Jimmy",
      last_name: "Smits",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      terms_conditions: true,
      privacy: true,
      data_access: true,
      slam_id: nil
    )

    Repo.insert!(%Carer{carer: carer, caring: service_user_1})

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
    })

    {:ok, %{session: session}}
  end

  test "shows service users", %{session: session} do
    session
    |> resize_window(768, 1024)
    |> log_in("robert_macmurray@nhs.co.uk")
    |> click(Query.link("Caseload"))

    assert session |> has_text?("Tony Daly")
    assert session |> has_text?("Kat Bow")
  end

  test "shows carers", %{session: session} do
    session
    |> resize_window(768, 1024)
    |> log_in("robert_macmurray@nhs.co.uk")
    |> click(Query.link("Caseload"))
    |> take_screenshot

    assert session |> has_text?("Jimmy Smits (friend/family/carer)")
  end

  test "view service user", %{session: session} do
    session
    |> resize_window(768, 1024)
    |> log_in("robert_macmurray@nhs.co.uk")
    |> click(Query.link("Caseload"))
    |> click(Query.link("Tony Daly"))
    |> click(Query.link("Details and contacts"))
    |> take_screenshot

    assert session |> has_text?("123 High Street")
    assert session |> has_text?("tony@dwyl.io")
  end

  test "service user send message", %{session: session} do
    session
    |> resize_window(768, 1024)
    |> log_in("robert_macmurray@nhs.co.uk")
    |> click(Query.link("Caseload"))
    |> click(Query.link("Tony Daly"))
    |> click(Query.link("Messages"))
  end

  test "view carer", %{session: session} do
    session
    |> resize_window(768, 1024)
    |> log_in("robert_macmurray@nhs.co.uk")
    |> click(Query.link("Caseload"))
    |> click(Query.link("Jimmy Smits (friend/family/carer)"))
    |> click(Query.link("Details and contacts"))
    |> take_screenshot

    assert session |> has_text?("Jimmy Smits")
  end

  test "view tracking overview", %{session: session} do
    session
    |> resize_window(768, 1024)
    |> log_in("robert_macmurray@nhs.co.uk")
    |> click(Query.link("Caseload"))
    |> click(Query.link("Tony Daly"))
    |> click(Query.link("Tracking"))
    |> take_screenshot

    assert has_text?(session, "Tracking overview")
  end

  test "view goals and strategies", %{session: session} do
    session
    |> resize_window(768, 1024)
    |> log_in("robert_macmurray@nhs.co.uk")
    |> click(Query.link("Caseload"))
    |> click(Query.link("Tony Daly"))
    |> click(Query.link("Goals and strategies"))
    |> take_screenshot

    assert has_text?(session, "No goals yet created")
  end
end
