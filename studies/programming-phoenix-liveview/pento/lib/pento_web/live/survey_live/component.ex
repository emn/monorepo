defmodule PentoWeb.SurveyLive.Component do
  alias PentoWeb.SurveyLive.Component
  use Phoenix.Component

  attr :content, :string, required: true
  slot :inner_block, required: true

  def hero(assigns) do
    ~H"""
    <h1 class="font-heavy text-3xl">
      <%= @content %>
    </h1>
    <h3><%= render_slot(@inner_block) %></h3>
    """
  end

  slot :inner_block, required: true

  def list_item(assigns) do
    ~H"""
    <li>
      <%= render_slot(@inner_block) %>
    </li>
    """
  end

  attr :items, :list

  def list(assigns) do
    ~H"""
    <ul>
      <%= for item <- @items do %>
        <Component.list_item><%= item %></Component.list_item>
      <% end %>
    </ul>
    """
  end
end
