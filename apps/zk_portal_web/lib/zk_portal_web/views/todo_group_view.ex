defmodule ZkPortalWeb.TodoGroupView do
  use ZkPortalWeb, :view

  alias ZkPortalWeb.TodoItemView;

  def render("todos.all.json", %{todos: todos}) do
    Enum.map(todos, &as_json/1)
  end

  defp as_json(group) do
    %{
      id: group.id,
      name: group.name,
      order: group.order,
      isArchived: group.is_archived,
      items: Enum.map(group.todo_items, &TodoItemView.as_json/1)
    }
  end
end