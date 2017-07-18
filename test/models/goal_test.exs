defmodule App.GoalTest do
  use App.ModelCase, async: true
  alias App.Goal

  @valid_attrs %{
    content: "some content",
    completed: false,
    notes: "some notes",
    important: true,
    steps: []
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Goal.changeset(%Goal{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Goal.changeset(%Goal{}, @invalid_attrs)
    refute changeset.valid?
  end
end
