defmodule App.EPJSPatientAddressDetails do
  use App.Web, :model

  @primary_key {:Address_ID, :integer, autogenerate: false}
  schema "mhlPatientAddressDetails" do
    field :Patient_ID, :integer
    field :Address1, :string
    field :Address2, :string
    field :Address3, :string
    field :Address4, :string
    field :Address5, :string
    field :Post_Code, :string
    field :Tel_home, :string
    field :Tel_Mobile, :string
    field :Tel_Work, :string
    field :Email_Address, :string
  end
end
