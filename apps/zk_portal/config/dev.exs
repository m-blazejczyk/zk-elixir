use Mix.Config

# Configure your database
config :zk_portal, ZkPortal.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "",
  database: "zk",
  hostname: "localhost",
  pool_size: 10
