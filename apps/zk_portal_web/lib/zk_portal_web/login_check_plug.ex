defmodule ZkPortalWeb.LoginCheckPlug do
  import Plug.Conn

  alias ZkPortalWeb.LoginRegistry

  def init(opts \\ []) do
    opts
  end

  def call(conn, _opts) do
    with [token] <- get_req_header(conn, "authorization"),
         {:ok, user} <- LoginRegistry.verify(token)
    do
      conn |> assign(:user, user)
    else
      _ -> conn |> send_resp(:unauthorized, "") |> halt()
    end
  end
end