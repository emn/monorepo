defmodule PentoWeb.SearchLive do
  use PentoWeb, :live_view
  alias Pento.Search.Query

  def mount(_params, _session, sock) do
    changeset = Query.changeset(%Query{}, %{sku: ""})
    {:ok, assign(sock, :form, to_form(changeset))}
  end

  def handle_event("validate", params, socket) do
    changeset =
      %Query{}
      |> Query.changeset(params["query"])
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("search", params, socket) do
    if p = Pento.Catalog.get_product_by_sku!(params["query"]["sku"]) do
      {:noreply, push_navigate(socket, to: ~p"/products/#{p.id}")}
    else
      {:noreply, socket |> put_flash(:error, "Product not found")}
    end
  end
end
