defmodule Pento.Search.Query do
  defstruct [:sku]
  @types %{sku: :string}
  import Ecto.Changeset

  def changeset(%__MODULE__{} = query, attrs) do
    {query, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:sku])
    |> validate_length(:sku, is: 7, message: "should be 7 digits")
  end
end
