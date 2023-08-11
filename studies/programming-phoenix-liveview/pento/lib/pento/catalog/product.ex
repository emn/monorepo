defmodule Pento.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Pento.Catalog.Product

  schema "products" do
    field :name, :string
    field :description, :string
    field :unit_price, :float
    field :sku, :integer
    field :image_upload, :string

    timestamps()
  end

  @doc false
  def changeset(product, attrs \\ %{}) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku, :image_upload])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> unique_constraint(:sku)
    |> validate_number(:unit_price, greater_than: 0.0)
  end

  def decrease_price(product, price) do
    product
    |> cast(%{unit_price: price}, [:unit_price])
    |> validate_required([:name, :description, :unit_price, :image_upload, :sku])
    |> unique_constraint(:sku)
    |> validate_number(:unit_price, less_than: product.unit_price)
    |> validate_number(:unit_price, greater_than: 0.0)
  end

  def sku_query(sku) do
    from p in Product, where: [sku: ^sku]
  end
end
