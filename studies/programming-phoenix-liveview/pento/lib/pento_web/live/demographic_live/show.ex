defmodule PentoWeb.DemographicLive.Show do
  use Phoenix.Component
  use Phoenix.HTML
  alias Pento.Survey.Demographic
  alias PentoWeb.CoreComponents

  def details(assigns) do
    ~H"""
    <div>
      <h2 class="font-medium text-2xl">Demographics <%= raw("&#x2713;") %></h2>
      <CoreComponents.table id="table" rows={@streams.demographic}>
        <:col :let={{_id, demographic}} label="Gender"><%= demographic.gender %></:col>
        <:col :let={{_id, demographic}} label="DOB"><%= demographic.dob %></:col>
      </CoreComponents.table>
    </div>
    """
  end

  slot :inner_block, required: true

  def title(assigns) do
    ~H"""
    <h1><%= @heading %></h1>
    <h2><i><%= render_slot(@inner_block) %></i></h2>
    """
  end
end
