defmodule Healthlocker.ServiceUserMessageTest do
  use Healthlocker.FeatureCase
  alias Healthlocker.{Room, User, UserRoom}

  setup %{session: session} do
    %User{
      id: 1234,
      first_name: "My",
      last_name: "Name",
      email: "tony@dwyl.io",
      dob: "01/01/2000",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      role: "service_user"
    } |> Repo.insert!

    %Room{
      id: 1,
      name: "service-user-care-team:1236"
    } |> Repo.insert

    %UserRoom{
      id: 1,
      user_id: 1234,
      room_id: 1
    } |> Repo.insert

    session = session |> log_in
    {:ok, %{session: session}}
  end

  @nav Query.css("#open-nav")
  @care_team_link Query.link("Care team")
  @message_input Query.css("#message-input")
  @contacts_link Query.link("Contacts")

  test "view messages", %{session: session} do
    session
    |> click(@nav)
    |> click(@care_team_link)

    assert current_path(session) =~ "/care-team/rooms/"
    assert has_text?(session, "Messages")
  end

  test "send messages", %{session: session} do
    session
    |> click(@nav)
    |> click(@care_team_link)
    |> fill_in(@message_input, with: "Hi there")
    |> send_keys([:enter])
    |> has_text?("Hi there")
  end

  test "can click on contacts", %{session: session} do
    session
    |> click(@nav)
    |> click(@care_team_link)
    |> click(@contacts_link)

    assert has_text?(session, "Your care team")
  end
end
