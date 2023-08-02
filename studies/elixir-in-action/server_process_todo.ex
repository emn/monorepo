defimpl Collectable, for: TodoList do
  def into(o) do
    {o, &into_callback/2}
  end

  defp into_callback(todo, {:cont, entry}) do
    TodoList.add_entry(todo, entry)
  end

  defp into_callback(todo, :done), do: todo
  defp into_callback(_todo, :halt), do: :ok
end

defmodule TodoList do
  defstruct next_id: 1, entries: %{}

  @spec new :: map
  def new(), do: %TodoList{}

  @spec new(map) :: map
  def new(entries \\ []) do
    Enum.reduce(entries, %TodoList{}, &add_entry(&2, &1))
  end

  @spec add_entry(map, map) :: map
  def add_entry(todo, entry) do
    entry = Map.put(entry, :id, todo.next_id)

    new_entries = Map.put(todo.entries, todo.next_id, entry)

    %TodoList{todo | entries: new_entries, next_id: todo.next_id + 1}
  end

  @spec entries(map, Date.t()) :: list
  def entries(todo, date) do
    todo.entries
    |> Map.values()
    |> Enum.filter(fn x -> x.date == date end)
  end

  @spec update_entry(map, number, fun) :: map
  def update_entry(todo, id, fun) do
    case Map.fetch(todo.entries, id) do
      :error ->
        todo

      {:ok, old_entry} ->
        new_entry = fun.(old_entry)
        new_entries = Map.put(todo.entries, new_entry.id, new_entry)
        %TodoList{todo | entries: new_entries}
    end
  end

  def delete_entry(todo, id) do
    %TodoList{todo | entries: Map.delete(todo.entries, id)}
  end
end

defmodule TodoList.CsvImporter do
  import TodoList
  @spec import(String.t()) :: map
  def import(path) do
    path
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(fn x ->
      [d, t] = String.split(x, ",")
      %{date: Date.from_iso8601(d), title: t}
    end)
    |> Enum.reduce(%TodoList{}, &add_entry(&2, &1))
  end
end

defmodule TodoServer do
  def start do
    ServerProcess.start(TodoServer)
  end

  def init do
    %TodoList{}
  end

  def add_entry(pid, e) do
    ServerProcess.cast(pid, {:add_entry, e})
  end

  def entries(pid, date) do
    ServerProcess.call(pid, {:entries, date})
  end

  def update_entry(pid, i, e) do
    ServerProcess.cast(pid, {:update_entry, i, e})
  end

  def delete_entry(pid, i) do
    ServerProcess.cast(pid, {:delete_entry, i})
  end

  def handle_cast({:add_entry, e}, t) do
    {:ok, TodoList.add_entry(t, e)}
  end

  def handle_cast({:update_entry, i, e}, t) do
    {:ok, TodoList.update_entry(t, i, e)}
  end

  def handle_cast({:delete_entry, i}, t) do
    {:ok, TodoList.delete_entry(t, i)}
  end

  def handle_call({:entries, d}, t) do
    {{:todo_entries, TodoList.entries(t, d)}, t}
  end
end

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
    after
      5000 ->
        {:error, :timeout}
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
        {_res, state2} = callback.handle_cast(req, state)
        loop(callback, state2)
    end
  end
end
