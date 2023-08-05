defmodule Todo.Cache do
  def start_link do
    IO.puts("Starting todo cache #{inspect(self())}")
    DynamicSupervisor.start_link(name: __MODULE__, strategy: :one_for_one)
  end

  def server_process(name) do
    case start_child(name) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end

  def child_spec(_) do
    %{id: __MODULE__, start: {__MODULE__, :start_link, []}, type: :supervisor}
  end

  defp start_child(todo) do
    DynamicSupervisor.start_child(__MODULE__, {Todo.Server, todo})
  end
end
