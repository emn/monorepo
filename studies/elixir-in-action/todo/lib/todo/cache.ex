defmodule Todo.Cache do
  use GenServer

  @impl GenServer
  def init(_) do
    Todo.Database.start()
    {:ok, %{}}
  end

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def server_process(pid, name) do
    GenServer.call(pid, {:server_process, name})
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
