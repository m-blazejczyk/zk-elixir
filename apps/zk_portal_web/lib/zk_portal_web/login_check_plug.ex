defmodule ZkPortalWeb.LoginCheckPlug do
  import Plug.Conn

  require Logger

  alias ZkPortalWeb.LoginRegistry

  def init(opts \\ []) do
    opts
  end

  def call(conn, _opts) do
    with [token] <- get_req_header(conn, "authorization"),
         {:ok, user} <- LoginRegistry.verify(token)
    do
      Logger.debug "Found valid auth token for user #{user.userName}"
      conn |> assign(:user, user)
    else
      :error -> 
        Logger.info "Unrecognized auth token"
        conn |> send_resp(:unauthorized, "") |> halt()
      _ ->
        Logger.info "Missing auth token"
        conn |> send_resp(:unauthorized, "") |> halt()
    end
  end
end