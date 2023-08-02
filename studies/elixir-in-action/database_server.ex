defmodule DatabaseServer do
  @spec start :: pid
  def start do
    spawn(fn ->
      conn = :rand.uniform(1000)
      loop(conn)
    end)
  end

  @spec run_async(pid, any) :: tuple
  def run_async(server_pid, query_def) do
    send(server_pid, {:run_query, self(), query_def})
  end

  @spec get_result :: String.t() || tuple
  def get_result do
    receive do
      {:query_result, result} ->
        result
    after
      5000 -> {:error, :timeout}
    end
  end

  defp loop(conn) do
    receive do
      {:run_query, caller, query_def} ->
        query_result = run_query(conn, query_def)
        send(caller, {:query_result, query_result})
    end

    loop(conn)
  end

  @spec run_query(number, any) :: String.t()
  defp run_query(conn, query_def) do
    Process.sleep(2000)
    "Connection #{conn}:\t#{query_def} result"
  end
end
