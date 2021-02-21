defmodule ZkPortalWeb.ReviewView do
  use ZkPortalWeb, :view

  def render("reviews.all.json", %{reviews: reviews}) do
    Enum.map(reviews, &review_json/1)
  end

  defp review_json(review) do
    %{
      id: review.id,
      page_name: review.page_name,
      title: review.title,
      author: review.author,
      pub_date: review.pub_date,
      comics_author: review.comics_author,
      comics_title: review.comics_title,
      publisher: review.publisher,
      publisher_url: review.publisher_url,
      review: review.review,
      info: review.info,
      buy_urls: review.buy_urls
    }
  end
end