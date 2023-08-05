defmodule Todo.Database do
  @pool_size 3
  @db_folder "./persist"

  def store(key, data) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.store(key, data)
  end

  def get(key) do
    Todo.DatabaseWorker.get(choose_worker(key), key)
  end

  def start_link do
    IO.puts("Starting todo database supervisor #{inspect(self())}")
    File.mkdir_p!(@db_folder)

    pool = Enum.map(1..@pool_size, &worker_spec/1)
    Supervisor.start_link(pool, strategy: :one_for_one)
  end

  defp worker_spec(worker_id) do
    default_spec = {Todo.DatabaseWorker, {@db_folder, worker_id}}
    Supervisor.child_spec(default_spec, id: worker_id)
  end

  def child_spec(_) do
    %{id: __MODULE__, start: {__MODULE__, :start_link, []}, type: :supervisor}
  end

  def choose_worker(key) do
    :erlang.phash2(key, @pool_size) + 1
  end
end
