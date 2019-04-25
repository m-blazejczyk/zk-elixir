defmodule ZkPortalWeb.TodoController do
  use ZkPortalWeb, :controller
  use Params

  require Logger

  import Plug.Conn

  def all(conn, _params) do
    todos = ZkPortal.list_todos
    Logger.info "Returning all #{length(todos)} todos(s) to user #{conn.assigns.user.userName}"
    render conn, "todos.all.json", todos: todos
  end
end