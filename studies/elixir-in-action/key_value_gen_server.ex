defmodule KeyValueStore do
  use GenServer

  def start do
    GenServer.start(__MODULE__, nil, name: :kv)
  end

  def put(k, v) do
    GenServer.cast(:kv, {:put, k, v})
  end

  def get(k) do
    GenServer.call(:kv, {:get, k})
  end

  @impl GenServer
  def init(_) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_cast({:put, k, v}, state) do
    {:noreply, Map.put(state, k, v)}
  end

  @impl GenServer
  def handle_call({:get, k}, _, state) do
    {:reply, Map.get(state, k), state}
  end
end
