defmodule ServerProcess do
  def start(callback) do
    spawn(fn ->
      init = callback.init()
      loop(callback, init)
    end)
  end

  def call(pid, req) do
    send(pid, {:call, req, self()})

    receive do
      {:response, res} -> res
    end
  end

  def cast(pid, req) do
    send(pid, {:cast, req})
  end

  defp loop(callback, state) do
    receive do
      {:call, req, caller} ->
        {res, state2} = callback.handle_call(req, state)
        send(caller, {:response, res})
        loop(callback, state2)

      {:cast, req} ->
        {res, state2} = callback.handle_cast(req, state)
        loop(callback, state2)
    end
  end
end

defmodule KeyValueStore do
  def start do
    ServerProcess.start(KeyValueStore)
  end

  def put(pid, k, v) do
    ServerProcess.cast(pid, {:put, k, v})
  end

  def get(pid, k) do
    ServerProcess.call(pid, {:get, k})
  end

  def init do
    %{}
  end

  def handle_cast({:put, k, v}, state) do
    {:ok, Map.put(state, k, v)}
  end

  def handle_call({:get, k}, state) do
    {Map.get(state, k), state}
  end
end
