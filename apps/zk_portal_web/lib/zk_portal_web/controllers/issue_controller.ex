defmodule ZkPortalWeb.IssueController do
  use ZkPortalWeb, :controller
  use Params

  require Logger

  def all(conn, _params) do
    issues = ZkPortal.list_issues
    Logger.info "Returning all #{length(issues)} issue(s) to user #{conn.assigns.user.userName}"
    render conn, "issues.all.json", issues: issues
  end

  def delete(conn, %{"id" => id}) do
    Logger.info "User #{conn.assigns.user.userName} tries deleting the issue with id #{id}…"
    case Integer.parse(id) do
      {iid, _} ->
        case ZkPortal.delete_issue(%ZkPortal.Issue{id: iid}) do
          {:ok, _} ->
            Logger.info "…and succeeds"
            conn |> send_resp(:ok, "")
          {:error, err} ->
            Logger.error "…and fails due to #{inspect err}"
            conn |> send_resp(:bad_request, "")
        end        
      :error ->
        Logger.error "…and fails due to invalid id"
        conn |> send_resp(:bad_request, "")
    end
  end
  def delete(conn, _) do
    Logger.info "User #{conn.assigns.user.userName} tries deleting an issue but fails: no id provided"
    conn |> send_resp(:bad_request, "")
  end
  
  def new(conn, _params) do
    issue = ZkPortal.new_issue
    Logger.info "User #{conn.assigns.user.userName} created a new issue"
    render conn, "issue.new.json", issue: issue
  end

  def update_issue(conn, params) do
    Logger.info "User #{conn.assigns.user.userName} tries updating an issue with #{inspect params}..."
  end

  def update_issue_lang(conn, params) do
    Logger.info "User #{conn.assigns.user.userName} tries updating an issue_lang with #{inspect params}..."
  end
end