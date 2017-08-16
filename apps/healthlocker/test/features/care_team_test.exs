defmodule Healthlocker.CareTeamTest do
  use Healthlocker.FeatureCase
  alias Healthlocker.{Carer, Room, User, UserRoom}

  setup %{session: session} do
    %User{
      id: 1234,
      first_name: "My",
      last_name: "Name",
      email: "service_user@gmail.com",
      dob: "01/01/2000",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      role: "service_user"
    } |> Repo.insert!

    %User{
      id: 1236,
      first_name: "My",
      last_name: "Name",
      email: "tony@dwyl.io",
      password_hash: Comeonin.Bcrypt.hashpwsalt("password"),
      role: "carer"
    } |> Repo.insert!

    %Carer{
      caring_id: 1234,
      carer_id: 1236
    } |> Repo.insert!

    %Room{
      id: 1,
      name: "carer-care-team:1236"
    } |> Repo.insert

    %UserRoom{
      id: 1,
      user_id: 1236,
      room_id: 1
    } |> Repo.insert

    session = session |> log_in
    {:ok, %{session: session}}
  end

  @nav_button Query.css("#open-nav")
  @care_team_link Query.link("Care team")
  @message_input Query.css("#message-input")
  @contacts_link Query.link("Contacts")

  describe "when the user is connected as a carer" do
    test "can see Care team menu", %{session: session} do
      session
      |> click(@nav_button)
      |> find(@care_team_link)
    end

    test "can send messages", %{session: session} do
      session
      |> click(@nav_button)
      |> click(@care_team_link)
      |> fill_in(@message_input, with: "Hello")
      |> send_keys([:enter])
      |> has_text?("Hello")
    end

    test "can click on contacts", %{session: session} do
      session
      |> click(@nav_button)
      |> click(@care_team_link)
      |> click(@contacts_link)

      assert has_text?(session, "'s care team")
    end
  end
end
