defmodule ZkPortalWeb.Router do
  use ZkPortalWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth/login", ZkPortalWeb do
    pipe_through :api

    post "/", LoginController, :login
  end

  scope "/", ZkPortalWeb do
    pipe_through :api

    delete "/banners/:id", BannerController, :delete
    post "/banners/new", BannerController, :new
    get "/banners", BannerController, :all
    post "/banners/:id/update", BannerController, :update
  end
end
