defmodule Healthlocker.CarerMessageTest do
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
  test "view care team messages", %{session: session} do
    session
    |> click(@nav_button)
    |> click(Query.link("Care team"))

    has_text?(session, "Message feed")
  end

  @message_field  Query.css("#message-input")
  @messages_list  Query.css("#message-feed")
  test "send care team message", %{session: session} do
    session
    |> click(@nav_button)
    |> click(Query.link("Care team"))
    |> fill_in(@message_field, with: "Hello there")
    |> send_keys([:enter])
    |> find(@messages_list, fn(messages) ->
      messages
      |> has_text?("Hello there")
    end)
  end
end
