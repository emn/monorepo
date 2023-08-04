defmodule Todo.Server do
  use GenServer

  def start(name) do
    GenServer.start_link(__MODULE__, name)
  end

  @impl GenServer
  def init(name) do
    IO.puts("Starting todo server #{inspect(self())}")
    {:ok, {name, nil}, {:continue, :init}}
  end

  def add_entry(p, e) do
    GenServer.cast(p, {:add_entry, e})
  end

  def entries(p, date) do
    GenServer.call(p, {:entries, date})
  end

  def update_entry(p, i, e) do
    GenServer.cast(p, {:update_entry, i, e})
  end

  def delete_entry(p, i) do
    GenServer.cast(p, {:delete_entry, i})
  end

  @impl GenServer
  def handle_continue(:init, {name, nil}) do
    state = Todo.Database.get(name) || Todo.List.new()
    {:noreply, {name, state}}
  end

  @impl GenServer
  def handle_cast({:add_entry, e}, {n, t}) do
    newt = Todo.List.add_entry(t, e)
    Todo.Database.store(n, newt)
    {:noreply, {n, newt}}
  end

  @impl GenServer
  def handle_cast({:update_entry, i, e}, {n, t}) do
    {:noreply, {n, Todo.List.update_entry(t, i, e)}}
  end

  @impl GenServer
  def handle_cast({:delete_entry, i}, {n, t}) do
    {:noreply, {n, Todo.List.delete_entry(t, i)}}
  end

  @impl GenServer
  def handle_call({:entries, d}, _caller, {_n, t} = s) do
    {:reply, {:todo_entries, Todo.List.entries(t, d)}, s}
  end
end
