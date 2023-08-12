defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view
  alias __MODULE__.Component
  alias PentoWeb.DemographicLive

  def mount(_, _, sock) do
    # sock = assign_demographic(sock)

    {:ok,
     stream(
       sock,
       :demographic,
       [
         Pento.Survey.get_demographic_by_user!(sock.assigns.current_user)
       ]
       # dom_id: &"demographic-#{&1.id}"
     )}
  end

  def assign_demographic(sock) do
    assign(sock, :demographic, Pento.Survey.get_demographic_by_user!(sock.assigns.current_user))
  end
end
