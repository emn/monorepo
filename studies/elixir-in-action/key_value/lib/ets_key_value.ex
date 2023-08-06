defmodule EtsKeyValue do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    :ets.new(__MODULE__, [:named_table, :public, write_concurrency: true])
    {:ok, nil}
  end

  def put(k, v) do
    :ets.insert(__MODULE__, {k, v})
  end

  def get(k) do
    case :ets.lookup(__MODULE__, k) do
      [{^k, v}] -> v
      [] -> nil
    end
  end
end
