defmodule MultiDict do
  def new(), do: %{}

  def add(dict, key, value) do
    Map.update(dict, key, value, fn values -> [value, values] end)
  end

  def get(dict, key) do
    Map.get(dict, key, [])
  end
end

defmodule TodoList do
  defstruct next_id: 1, entries: %{}

  def new(entries \\ []) do
    Enum.reduce(entries, %TodoList{}, fn entry, todo_list_acc ->
      add_entry(todo_list_acc, entry)
    end)
  end

  def add_entry(todo_list, entry) do
    entry = Map.put(entry, :id, todo_list.next_id)

    new_entries = Map.put(todo_list.entries, todo_list.next_id, entry)

    %TodoList{todo_list | entries: new_entries, next_id: todo_list.next_id + 1}
  end

  def entries(todo_list, date) do
    todo_list.entries |> Map.values() |> Enum.filter(fn entry -> entry.date == date end)
  end

  def update_entry(todo_list, entry_id, updater_fn) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error ->
        todo_list

      {:ok, old_entry} ->
        new_entry = updater_fn.(old_entry)
        new_entries = Map.put(todo_list.entries, entry_id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
  end

  def delete_entry(todo_list, entry_id) do
    new_entries =
      todo_list.entries |> Map.values() |> Enum.reject(fn entry -> entry.id == entry_id end)

    %TodoList{todo_list | entries: new_entries}
  end
end

defmodule Fraction do
  defstruct a: nil, b: nil

  def new(a, b) do
    %Fraction{a: a, b: b}
  end

  def value(%{a: a, b: b}) do
    a / b
  end
end

defmodule TodoList.CsvImporter do
  def import_file!(path) do
    File.stream!(path) |> Stream.map(fn line -> String.trim_trailing(line, "\n") end)
  end

  def import(path) do
    import_file!(path)
    |> Stream.map(fn entry -> String.split(entry, ",") end)
    |> Stream.map(fn [date, title] ->
      %{date: date, title: title}
    end)
    |> TodoList.new()
  end
end
