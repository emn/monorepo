defmodule Pento.Promo do
  alias Pento.Promo.Recipient

  def change_recipient(%Recipient{} = rec, attrs \\ %{}) do
    Recipient.changeset(rec, attrs)
  end

  def send_promo(rec, _attrs) do
    {:ok, rec}
  end
end
