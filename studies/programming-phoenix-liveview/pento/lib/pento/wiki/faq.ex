defmodule Pento.Wiki.Faq do
  use Ecto.Schema
  import Ecto.Changeset

  schema "faqs" do
    field :question, :string
    field :answer, :string
    field :upvotes, :integer

    timestamps()
  end

  @doc false
  def changeset(faq, attrs) do
    faq
    |> cast(attrs, [:question, :answer, :upvotes])
    |> validate_required([:question, :answer, :upvotes])
  end
end
