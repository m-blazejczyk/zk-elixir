defmodule ZkPortalWeb.LoginController do
  use ZkPortalWeb, :controller

  alias ZkPortalWeb.LoginInfo;

  import Plug.Conn;

  def login(conn, %{"user" => user_name, "password" => password}) do
    user = LoginInfo.find_user(user_name, password)
    if user do
      token = "TTTKKK"
      render conn, "user.json", user: user, token: token
    else
      conn |> send_resp(:unauthorized, "")
    end
  end
  def login(conn, _params) do
    conn |> send_resp(:bad_request, "")
  end
end