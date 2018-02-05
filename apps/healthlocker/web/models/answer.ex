defmodule Healthlocker.Answer do
  use Healthlocker.Web, :model

  schema "answers" do
    field :section, :string
    field :question, :string
    field :answer, :string
    belongs_to :su, Answers.Su, foreign_key: :su_id
    belongs_to :last_updated_by, Answers.LatUpdatedBy, foreign_key: :last_updated_by_id

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:section, :question, :answer, :su_id, :last_updated_by_id])
    |> validate_required([:su, :last_updated_by])
  end

  def get_section(str) do
    Healthlocker.ComponentView.get_options(str)
    |> Enum.with_index(1)
    |> index_to_atom
  end

  def index_to_atom(list) do
    Enum.map(list, fn {q, key} ->
      atom = key |> Integer.to_string |> String.to_atom
      {q, atom}
    end)
  end
end
