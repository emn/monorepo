defmodule Pento.Promo.Recipient do
  defstruct [:fname, :email]
  @types %{fname: :string, email: :string}
  import Ecto.Changeset

  def changeset(%__MODULE__{} = user, attrs) do
    {user, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:fname, :email])
    |> validate_format(:email, ~r/@/)
  end
end
