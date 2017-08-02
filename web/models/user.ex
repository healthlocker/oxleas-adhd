defmodule OxleasAdhd.User do
  use OxleasAdhd.Web, :model

  alias Comeonin.Bcrypt

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :first_name, :string
    field :last_name, :string
    field :phone_number, :string
    field :security_question, :string
    field :security_answer, :string
    field :data_access, :boolean
    field :c4c, :boolean
    field :comms_consent, :boolean
    field :role, :string
    field :slam_id, :integer
    field :user_guid, :string
    field :reset_password_token, :string
    field :reset_token_sent_at, :utc_datetime
    field :job_role, :string
    field :dob, :string
    field :relationship, :string
    has_many :posts, OxleasAdhd.Post
    many_to_many :likes, OxleasAdhd.Post, join_through: "posts_likes", on_replace: :delete, on_delete: :delete_all
    many_to_many :relationships, OxleasAdhd.User, join_through: OxleasAdhd.Relationship, on_replace: :delete, on_delete: :delete_all

    many_to_many :carers, OxleasAdhd.User, join_through: OxleasAdhd.Carer, join_keys: [caring_id: :id, carer_id: :id]
    many_to_many :caring, OxleasAdhd.User, join_through: OxleasAdhd.Carer, join_keys: [carer_id: :id, caring_id: :id]

    many_to_many :rooms, OxleasAdhd.Room, join_through: "user_rooms"
    has_many :messages, OxleasAdhd.Message
    has_many :symptoms, OxleasAdhd.Symptom
    has_many :diaries, OxleasAdhd.Diary

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset_staff(struct, params \\ :invalid) do
    struct
    |> cast(params, [:first_name, :last_name, :job_role, :email, :password])
    |> update_change(:email, &(String.downcase(&1)))
    |> put_change(:role, "clinician")
    |> validate_format(:email, ~r/@/)
    |> validate_required([:first_name, :last_name, :job_role, :email, :password])
    |> unique_constraint(:email, message: "Sorry you cannot create an account at
    this time, try again later or with different details.")
  end

  def changeset_service_user(struct, params \\ :invalid) do
    struct
    |> cast(params, [:first_name, :last_name, :dob, :email, :password])
    |> update_change(:email, &(String.downcase(&1)))
    |> put_change(:role, "service_user")
    |> validate_format(:email, ~r/@/)
    |> validate_required([:first_name, :last_name, :dob, :email, :password])
    |> unique_constraint(:email, message: "Sorry you cannot create an account at
    this time, try again later or with different details.")
  end

  def changeset_carer(struct, params \\ :invalid) do
    struct
    |> cast(params, [:first_name, :last_name, :relationship, :email, :password])
    |> update_change(:email, &(String.downcase(&1)))
    |> put_change(:role, "carer")
    |> validate_format(:email, ~r/@/)
    |> validate_required([:first_name, :last_name, :relationship, :email, :password])
    |> unique_constraint(:email, message: "Sorry you cannot create an account at
    this time, try again later or with different details.")
  end

  def update_changeset(struct, params \\ :invalid) do
    struct
    |> cast(params, [:email, :first_name, :last_name, :phone_number])
    |> update_change(:email, &(String.downcase(&1)))
    |> validate_format(:email, ~r/@/)
    |> validate_required(:email)
    |> unique_constraint(:email, message: "Sorry you cannot create an account at
    this time, try again later or with different details.")
  end

  def name_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:first_name, :last_name])
    |> validate_required([:first_name, :last_name])
  end

  def security_question(struct, params \\ :invalid) do
    struct
    |> cast(params, [:security_question, :security_answer])
    |> validate_required([:security_question, :security_answer])
  end

  def update_data_access(struct, params \\ :invalid) do
    struct
    |> cast(params, [:data_access, :c4c, :comms_consent])
  end

  def password_token_changeset(struct, params \\ :invalid) do
    struct
    |> cast(params, [:reset_password_token, :reset_token_sent_at])
  end

  def password_changeset(struct, params \\ :invalid) do
    struct
    |> cast(params, [:password])
  end

  def update_password(struct, params \\ :invalid) do
    struct
    |> password_changeset(params)
    |> cast(params, [:password])
    |> validate_length(:password, min: 6, max: 100)
    |> validate_confirmation(:password, message: "New passwords do not match")
    |> put_pass_hash()
  end

  def put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end