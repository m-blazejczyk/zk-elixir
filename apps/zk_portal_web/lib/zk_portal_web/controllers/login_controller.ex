defmodule ZkPortalWeb.LoginController do
  use ZkPortalWeb, :controller

  alias ZkPortalWeb.LoginInfo;
  alias ZkPortalWeb.LoginRegistry;

  import Plug.Conn;

  def login(conn, %{"user" => user_name, "password" => password}) do
    user = LoginInfo.find_user(user_name, password)
    if user do
      token = new_token()
      LoginRegistry.login({token, user})
      render conn, "user.json", user: user, token: token
    else
      conn |> send_resp(:unauthorized, "")
    end
  end
  def login(conn, _params) do
    conn |> send_resp(:bad_request, "")
  end

  defp new_token do
    length = 24
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end