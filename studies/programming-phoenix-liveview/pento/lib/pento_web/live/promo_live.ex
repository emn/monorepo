defmodule PentoWeb.PromoLive do
  use PentoWeb, :live_view
  alias Pento.Promo
  alias Pento.Promo.Recipient

  def mount(_params, _session, sock) do
    changeset = Promo.change_recipient(%Recipient{})

    {:ok, sock |> assign_form(changeset)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def handle_event("validate", %{"recipient" => recipient_params}, socket) do
    changeset =
      %Recipient{}
      |> Promo.change_recipient(recipient_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"recipient" => recipient_params}, socket) do
    :timer.sleep(1000)

    changeset =
      %Recipient{}
      |> Promo.change_recipient(recipient_params)

    if changeset.valid? do
      {:noreply, socket |> put_flash(:info, "Form submitted.")}
    else
      {:noreply,
       socket
       |> put_flash(:error, "Invalid.")}
    end
  end
end
