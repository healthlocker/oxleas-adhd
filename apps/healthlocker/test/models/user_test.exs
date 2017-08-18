defmodule Healthlocker.UserTest do
  use Healthlocker.ModelCase

  alias Healthlocker.User

  @update_attrs %{
    first_name: "My",
    last_name: "Name",
    email: "me@example.com",
    phone_number: "07512345678",
    slam_user: true
  }
  @update_password_attrs %{
    password: "password",
    password_confirmation: "password"
  }
  @invalid_password_attrs %{
    password: 1,
    password_confirmation: "abc123"
  }
  @invalid_attrs %{}

  test "update_changeset with valid attributes" do
    changeset = User.update_changeset(%User{}, @update_attrs)
    assert changeset.valid?
  end

  test "update_changeset with invalid attributes" do
    changeset = User.update_changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "update_password with valid attributes" do
    changeset = User.update_password(%User{}, @update_password_attrs)
    assert changeset.valid?
  end

  test "update_password with invalid attributes" do
    changeset = User.update_password(%User{}, @invalid_password_attrs)
    refute changeset.valid?
  end
end
