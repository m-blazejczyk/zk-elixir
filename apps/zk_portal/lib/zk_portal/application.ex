defmodule ZkPortal.Application do
  @moduledoc """
  The ZkPortal Application Service.

  The zk_portal system business domain lives in this application.

  Exposes API to clients such as the `ZkPortalWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(ZkPortal.Repo, []),
    ], strategy: :one_for_one, name: ZkPortal.Supervisor)
  end
end
