use Mix.Config

# Configure your database
config :zk_portal, ZkPortal.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "zk_portal_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
