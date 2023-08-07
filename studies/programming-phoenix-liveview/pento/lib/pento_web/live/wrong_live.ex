defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, sock) do
    {:ok,
     assign(sock,
       won: false,
       correct: :rand.uniform(10),
       score: 0,
       message: "Make a guess",
       time: time()
     )}
  end

  def handle_event("guess", %{"number" => guess}, sock) do
    time = time()
    score = sock.assigns.score

    case sock.assigns.correct == String.to_integer(guess) do
      true ->
        {:noreply, assign(sock, won: true, message: "Correct!", score: score + 1, time: time)}

      false ->
        {:noreply,
         assign(sock,
           message: "Your guess #{guess} is wrong. Try again.",
           score: score - 1,
           time: time
         )}
    end
  end

  def handle_params(_params, _uri, sock) when sock.assigns.won == true do
    {:noreply,
     assign(sock,
       won: false,
       correct: :rand.uniform(10),
       score: 0,
       message: "Make a guess",
       time: time()
     )}
  end

  def handle_params(_params, _uri, sock), do: {:noreply, sock}

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>Time: <%= @time %></h2>
    <h2><%= @message %></h2>
    <%= if !@won do %>
      <h3>
        <%= for n <- 1..10 do %>
          <.link href="#" phx-click="guess" phx-value-number={n}>
            <%= n %>
          </.link>
        <% end %>
      </h3>
    <% else %>
      <.link patch={~p"/guess"}>New Game</.link>
    <% end %>
    """
  end

  def time(), do: DateTime.utc_now() |> to_string
end
