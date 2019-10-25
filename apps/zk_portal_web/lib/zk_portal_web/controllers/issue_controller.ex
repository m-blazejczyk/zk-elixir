defmodule ZkPortalWeb.IssueController do
  use ZkPortalWeb, :controller
  use Params

  require Logger

  def all(conn, _params) do
    issues = ZkPortal.list_issues
    Logger.info "Returning all #{length(issues)} issue(s) to user #{conn.assigns.user.userName}"
    render conn, "issues.all.json", issues: issues
  end

  def new(conn, _params) do
    issue = ZkPortal.new_issue
    Logger.info "User #{conn.assigns.user.userName} created a new issue"
    render conn, "issue.new.json", issue: issue
  end

  def update(conn, params) do
    Logger.info "User #{conn.assigns.user.userName} tries updating an issue with #{inspect params}..."
  end
end