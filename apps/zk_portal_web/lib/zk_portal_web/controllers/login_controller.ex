defmodule ZkPortalWeb.LoginController do
  use ZkPortalWeb, :controller

  require Logger

  alias ZkPortalWeb.LoginInfo
  alias ZkPortalWeb.LoginRegistry

  import Plug.Conn

  def login(conn, %{"user" => user_name, "password" => password}) do
    user = LoginInfo.find_user(user_name, password)
    if user do
      Logger.info "Logging in user #{user_name}"
      token = new_token()
      LoginRegistry.login({token, user})
      render conn, "user.json", user: user, token: token
    else
      Logger.info "Unknown user #{user_name} or wrong password"
      conn |> send_resp(:unauthorized, "")
    end
  end
  def login(conn, _params) do
    Logger.info "Invalid login request"
    conn |> send_resp(:bad_request, "")
  end

  defp new_token do
    :crypto.strong_rand_bytes(20) |> Base.url_encode64
  end
end