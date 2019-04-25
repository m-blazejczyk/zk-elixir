defmodule ZkPortalWeb.TodoItemView do
  use ZkPortalWeb, :view

  # def render("todos.all.json", %{todos: todos}) do
  #   Enum.map(todos, &as_json/1)
  # end

  def as_json(item) do
    %{
      id: item.id,
      name: item.name,
      priority: item.priority,
      status: item.status,
      order: item.order
    }
  end
end