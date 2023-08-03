defmodule Todo.DatabaseWorker do
  use GenServer

  def start(dbdir) do
    GenServer.start(__MODULE__, dbdir)
  end

  def store(pid, key, data) do
    GenServer.cast(pid, {:store, key, data})
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  @impl GenServer
  def init(dbdir) do
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
