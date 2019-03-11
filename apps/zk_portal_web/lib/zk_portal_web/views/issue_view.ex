defmodule ZkPortalWeb.IssueView do
  use ZkPortalWeb, :view

  alias ZkPortalWeb.IssueLangView
  alias ZkPortalWeb.ImageView

  def render("issues.all.json", %{issues: issues}) do
    Enum.map(issues, &issue_json/1)
  end
  def render("issue.new.json", %{issue: issue}) do
    issue_json(issue)
  end

  defp issue_json(issue) do
    %{
      id: issue.id,
      availability: issue.availability,
      price: issue.price,
      pl: IssueLangView.as_json(issue.issue_pl),
      en: IssueLangView.as_json(issue.issue_en),
      image_big: ImageView.as_json(issue.image_big),
      image_medium: ImageView.as_json(issue.image_medium),
      image_small: ImageView.as_json(issue.image_small)
    }
  end
end