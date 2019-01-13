# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :zk_portal_web,
  namespace: ZkPortalWeb,
  ecto_repos: [ZkPortal.Repo]

# Configures the endpoint
config :zk_portal_web, ZkPortalWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "YaubRB2K6P4oHgqcNkXarNGEiAZRmdYhoA5Z7HPMgd2ah+5oXgxnPwulZV6ZNDHd",
  render_errors: [view: ZkPortalWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: ZkPortalWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :zk_portal_web, :generators,
  context_app: :zk_portal

config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
