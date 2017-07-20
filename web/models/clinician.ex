defmodule App.Clinician do
  use App.Web, :model

  @primary_key false
  schema "clinicians" do
    belongs_to :clinician, App.User
    belongs_to :caring, App.User
  end
end
