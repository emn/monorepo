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
    spawn(fn ->
      Process.register(self(), :todo)
      loop(TodoList.new())
    end)
  end

  def add_entry(e) do
    send(:todo, {:add_entry, e})
  end

  def entries(date) do
    send(:todo, {:entries, self(), date})

    receive do
      {:todo_entries, e} -> e
    after
      5000 -> {:error, :timeout}
    end
  end

  def update_entry(i, e) do
    send(:todo, {:update_entry, i, e})
  end

  def delete_entry(i) do
    send(:todo, {:delete_entry, i})
  end

  defp loop(t) do
    t2 =
      receive do
        msg -> handle_message(t, msg)
      end

    loop(t2)
  end

  defp handle_message(t, {:add_entry, e}) do
    TodoList.add_entry(t, e)
  end

  defp handle_message(t, {:entries, caller, d}) do
    send(caller, {:todo_entries, TodoList.entries(t, d)})
    t
  end

  defp handle_message(t, {:update_entry, i, e}) do
    TodoList.update_entry(t, i, e)
  end

  defp handle_message(t, {:delete_entry, i}) do
    TodoList.delete_entry(t, i)
  end
end
