defmodule ZkPortalWeb.Router do
  use ZkPortalWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :login_check do
    plug ZkPortalWeb.LoginCheckPlug
  end

  scope "/api/auth/login", ZkPortalWeb do
    pipe_through :api

    post "/", LoginController, :login
  end

  scope "/api", ZkPortalWeb do
    pipe_through [:api, :login_check]

    delete "/banners/:id", BannerController, :delete
    post "/banners/new", BannerController, :new
    get "/banners", BannerController, :all
    post "/banners/:id/update", BannerController, :update
    post "/banners/:id/upload", BannerController, :upload

    get "/todos", TodoController, :all

    delete "/issues/:id", IssueController, :delete
    post "/issues/new", IssueController, :new
    get "/issues", IssueController, :all
    post "/issues/:id/update", IssueController, :update_issue
    post "/issues-lang/:id/update", IssueController, :update_issue_lang
  end
end
