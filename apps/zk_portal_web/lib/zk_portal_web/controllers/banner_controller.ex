defmodule ZkPortalWeb.BannerController do
  use ZkPortalWeb, :controller
  use Params

  import Plug.Conn;

  def all(conn, _params) do
    banners = ZkPortal.list_banners
    render conn, "banners.all.json", banners: banners
  end

  def new(conn, _params) do
    banner = ZkPortal.new_banner
    render conn, "banner.new.json", banner: banner
  end

  # See https://hexdocs.pm/plug/Plug.Conn.Status.html
  def delete(conn, %{"id" => id}) do
    case Integer.parse(id) do
      {iid, _} ->
        case ZkPortal.delete_banner(%ZkPortal.Banner{id: iid}) do
          {:ok, _} ->
            conn |> send_resp(:ok, "")
          {:error, _} ->
            conn |> send_resp(:bad_request, "")
        end        
      :error ->
        conn |> send_resp(:bad_request, "")
    end
  end

  # See https://github.com/vic/params
  defparams update_params %{
    id!: :integer,     # required
    is_silent: :boolean,  # accepts lowercase values true and false
    start_date: :date,
    endDate: :date,
    url: :string,
    weight: :integer
  }

  def update(conn, params) do
    changeset = update_params(params)
    if changeset.valid? do
      validated_params = Params.to_map changeset
      case ZkPortal.update_banner(%ZkPortal.Banner{id: validated_params.id}, validated_params) do
        {:ok, _} ->
          conn |> send_resp(:ok, "")
        {:error, _} ->
          conn |> send_resp(:bad_request, "")
      end
    else
      conn |> send_resp(:bad_request, "")
    end
  end
end