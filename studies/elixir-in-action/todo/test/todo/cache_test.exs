defmodule Todo.CacheTest do
  use ExUnit.Case

  test "server_process" do
    {:ok, p} = Todo.Cache.start()
    l = Todo.Cache.server_process(p, "goats")

    assert l != Todo.Cache.server_process(p, "sheep")
    assert l == Todo.Cache.server_process(p, "goats")
  end

  test "todo operations" do
    {:ok, p} = Todo.Cache.start()
    a = Todo.Cache.server_process(p, "a")
    Todo.Server.add_entry(a, %{date: ~D[2023-12-20], title: "Boo"})

    assert {:todo_entries, [%{id: 1, date: ~D[2023-12-20], title: "Boo"}]} ==
             Todo.Server.entries(a, ~D[2023-12-20])

    Todo.Server.update_entry(a, 1, fn x -> %{x | title: "Bar"} end)

    assert {:todo_entries, [%{id: 1, date: ~D[2023-12-20], title: "Bar"}]} ==
             Todo.Server.entries(a, ~D[2023-12-20])

    Todo.Server.delete_entry(a, 1)
    assert {:todo_entries, []} == Todo.Server.entries(a, ~D[2023-12-20])

    c = Todo.Cache.server_process(p, "c")
    Todo.Server.add_entry(c, %{date: ~D[2023-12-20], title: "Boo"})

    assert {:todo_entries, [%{id: 1, date: ~D[2023-12-20], title: "Boo"}]} ==
             Todo.Server.entries(c, ~D[2023-12-20])

    Todo.Server.update_entry(c, 1, fn x -> %{x | title: "Bar"} end)

    assert {:todo_entries, [%{id: 1, date: ~D[2023-12-20], title: "Bar"}]} ==
             Todo.Server.entries(c, ~D[2023-12-20])

    Todo.Server.delete_entry(c, 1)
    assert {:todo_entries, []} == Todo.Server.entries(c, ~D[2023-12-20])
  end
end
