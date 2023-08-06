defmodule SimpleRegistry do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl GenServer
  def init(_) do
    Process.flag(:trap_exit, true)
    :ets.new(:registry, [:public, :named_table])
    {:ok, nil}
  end

  def register(k) do
    Process.link(GenServer.whereis(__MODULE__))

    case :ets.insert_new(:registry, {k, self()}) do
      true -> :ok
      false -> :error
    end
  end

  def whereis(k) do
    case :ets.lookup(:registry, k) do
      [{^k, v}] -> v
      [] -> nil
    end
  end

  @impl GenServer
  def handle_info({:EXIT, pid, _reason}, state) do
    :ets.match_delete(:registry, {:_, pid})
    {:noreply, state}
  end
end
