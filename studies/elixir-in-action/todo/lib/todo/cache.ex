defmodule Todo.Cache do
  use GenServer

  @impl GenServer
  def init(_) do
    IO.puts("Starting todo cache #{inspect(self())}")
    Todo.Database.start()
    {:ok, %{}}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def server_process(name) do
    GenServer.call(__MODULE__, {:server_process, name})
  end

  @impl GenServer
  def handle_call({:server_process, name}, _, s) do
    case Map.fetch(s, name) do
      {:ok, t} ->
        {:reply, t, s}

      :error ->
        {:ok, n} = Todo.Server.start(name)
        {:reply, n, Map.put(s, name, n)}
    end
  end
end
