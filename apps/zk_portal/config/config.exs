use Mix.Config

config :zk_portal, ecto_repos: [ZkPortal.Repo]

import_config "#{Mix.env}.exs"
