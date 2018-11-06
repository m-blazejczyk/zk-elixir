defmodule ZkPortalWeb.LoginView do
  use ZkPortalWeb, :view

  def render("user.json", %{user: user, token: token}) do
    %{
      token: token,
      userId: user.id,
      userName: user.userName,
      fullName: user.fullName,
      initials: user.initials
    }
  end
end