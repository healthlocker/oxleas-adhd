defmodule Healthlocker.Teacher do
  use Healthlocker.Web, :model

  @primary_key false
  schema "teachers" do
    belongs_to :teacher, Healthlocker.User
    belongs_to :caring, Healthlocker.User
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:teacher_id, :caring_id])
    |> validate_required([:teacher_id, :caring_id])
  end
end
