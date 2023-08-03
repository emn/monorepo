defmodule Todo.Database do
  use GenServer

  @db_folder "./persist"

  def start do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def store(key, data) do
    GenServer.cast(__MODULE__, {:store, key, data})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  @impl GenServer
  def init(_) do
    File.mkdir_p!(@db_folder)

    pool =
      Enum.reduce(0..2, %{}, fn x, y -> Map.put(y, x, Todo.DatabaseWorker.start(@db_folder)) end)

    {:ok, pool}
  end

  @impl GenServer
  def handle_cast({:store, key, data}, state) do
    Todo.DatabaseWorker.store(choose_worker(key, state), key, data)
    {:noreply, state}
  end

  @impl GenServer
  def handle_call({:get, key}, _caller, state) do
    w = choose_worker(key, state)
    data = Todo.DatabaseWorker.get(w, key)
    {:reply, data, state}
  end

  def choose_worker(key, pool) do
    case Map.get(pool, :erlang.phash2(key, 3)) do
      {:ok, pid} -> pid
    end
  end
end
