defmodule ZkPortalWeb.ReviewController do
  use ZkPortalWeb, :controller
  use Params

  require Logger

  def all(conn, _params) do
    reviews = ZkPortal.list_reviews
    Logger.info "Returning all #{length(reviews)} review(s) to user #{conn.assigns.user.userName}"
    render conn, "reviews.all.json", reviews: reviews
  end

  def insert(conn, params) do
    Logger.info "User #{conn.assigns.user.userName} created a new review with #{inspect params}…  NOT IMPLEMENTED"
  end

  def update(conn, params) do
    Logger.info "User #{conn.assigns.user.userName} tries updating a review with #{inspect params}…  NOT IMPLEMENTED"
  end
end