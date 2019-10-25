defmodule ZkPortalWeb.TodoController do
  use ZkPortalWeb, :controller
  use Params

  require Logger

  def all(conn, _params) do
    todos = ZkPortal.list_todos
    Logger.info "Returning all #{length(todos)} todos(s) to user #{conn.assigns.user.userName}"
    conn
      |> put_view(ZkPortalWeb.TodoGroupView)
      |> render("todos.all.json", todos: todos)
  end
end