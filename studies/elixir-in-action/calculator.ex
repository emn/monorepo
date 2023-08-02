defmodule Calculator do
  @spec start :: pid
  def start do
    spawn(fn -> loop(0) end)
  end

  @spec value(pid) :: number
  def value(pid) do
    send(pid, {:value, self()})

    receive do
      {:response, v} -> v
    end
  end

  @spec add(pid, number) :: tuple
  def add(pid, v), do: send(pid, {:add, v})
  @spec sub(pid, number) :: tuple
  def sub(pid, v), do: send(pid, {:sub, v})
  @spec mul(pid, number) :: tuple
  def mul(pid, v), do: send(pid, {:mul, v})
  @spec div(pid, number) :: tuple
  def div(pid, v), do: send(pid, {:div, v})

  defp loop(v) do
    new_v =
      receive do
        msg -> handle_message(v, msg)
      end

    loop(new_v)
  end

  @spec handle_message(number, tuple) :: number
  defp handle_message(v, {:add, v2}), do: v + v2
  defp handle_message(v, {:sub, v2}), do: v - v2
  defp handle_message(v, {:mul, v2}), do: v * v2
  defp handle_message(v, {:div, v2}), do: v / v2

  defp handle_message(v, {:value, p}) do
    send(p, {:response, v})
    v
  end
end
