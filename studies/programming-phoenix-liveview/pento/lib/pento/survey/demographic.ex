defmodule Pento.Survey.Demographic do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pento.Accounts.User

  schema "demographics" do
    field :gender, :string
    field :dob, :integer
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(demographic, attrs) do
    demographic
    |> cast(attrs, [:gender, :dob, :user_id])
    |> validate_required([:gender, :dob, :user_id])
    |> validate_inclusion(:gender, ["male", "female", "other"])
    |> validate_inclusion(:dob, 1900..2023)
    |> unique_constraint(:user_id)
  end
end
