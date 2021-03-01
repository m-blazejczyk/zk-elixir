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
      review: review.review,

      comics_author_1: review.comics_author_1,
      comics_title_1: review.comics_title_1,
      publisher_1: review.publisher_1,
      info_1: review.info_1,
      buy_urls_1: review.buy_urls_1,

      comics_author_2: review.comics_author_2,
      comics_title_2: review.comics_title_2,
      publisher_2: review.publisher_2,
      info_2: review.info_2,
      buy_urls_2: review.buy_urls_2
    }
  end
end