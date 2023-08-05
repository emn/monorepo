defmodule Todo.DatabaseWorker do
  use GenServer

  def start_link({dbdir, id}) do
    GenServer.start_link(__MODULE__, dbdir, name: via_tuple(id))
  end

  def store(id, key, data) do
    GenServer.cast(via_tuple(id), {:store, key, data})
  end

  def get(id, key) do
    GenServer.call(via_tuple(id), {:get, key})
  end

  defp via_tuple(id) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, id})
  end

  @impl GenServer
  def init(dbdir) do
    IO.puts("Starting todo database worker #{inspect(self())}")
    {:ok, dbdir}
  end

  @impl GenServer
  def handle_cast({:store, key, data}, dbdir) do
    IO.puts("#{inspect(self())}: storing #{inspect(key)}")
    File.write!(filename(dbdir, key), :erlang.term_to_binary(data))
    {:noreply, dbdir}
  end

  @impl GenServer
  def handle_call({:get, key}, _caller, dbdir) do
    IO.puts("#{inspect(self())}: retrieving #{inspect(key)}")

    data =
      case File.read(filename(dbdir, key)) do
        {:ok, contents} -> :erlang.binary_to_term(contents)
        _ -> nil
      end

    {:reply, data, dbdir}
  end

  defp filename(dir, key), do: Path.join(dir, to_string(key))
end
