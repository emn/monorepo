defmodule Todo.List do
  defstruct next_id: 1, entries: %{}
  @type t :: %Todo.List{}
  @spec new(any) :: Todo.List.t()
  def new(entries \\ []) do
    Enum.reduce(entries, %Todo.List{}, &add_entry(&2, &1))
  end

  @spec add_entry(Todo.List.t(), map) :: Todo.List.t()
  def add_entry(todo, entry) do
    entry = Map.put(entry, :id, todo.next_id)

    new_entries = Map.put(todo.entries, todo.next_id, entry)

    %Todo.List{todo | entries: new_entries, next_id: todo.next_id + 1}
  end

  @spec entries(Todo.List.t(), Date.t()) :: list
  def entries(todo, date) do
    todo.entries
    |> Map.values()
    |> Enum.filter(fn x -> x.date == date end)
  end

  @spec update_entry(Todo.List.t(), integer, fun) :: Todo.List.t()
  def update_entry(todo, id, fun) do
    case Map.fetch(todo.entries, id) do
      :error ->
        todo

      {:ok, old_entry} ->
        new_entry = fun.(old_entry)
        new_entries = Map.put(todo.entries, new_entry.id, new_entry)
        %Todo.List{todo | entries: new_entries}
    end
  end

  @spec delete_entry(Todo.List.t(), integer) :: Todo.List.t()
  def delete_entry(todo, id) do
    %Todo.List{todo | entries: Map.delete(todo.entries, id)}
  end
end
