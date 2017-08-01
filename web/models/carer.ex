defmodule OxleasAdhd.Carer do
  use OxleasAdhd.Web, :model

  @primary_key false
  schema "carers" do
    belongs_to :carer, OxleasAdhd.User
    belongs_to :caring, OxleasAdhd.User
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:carer_id, :caring_id])
    |> validate_required([:carer_id, :caring_id])
    |> unique_constraint(:carer_id, name: :carers_caring_id_carer_id_index)
  end
end
