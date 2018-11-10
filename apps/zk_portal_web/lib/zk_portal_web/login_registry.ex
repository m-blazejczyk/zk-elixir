defmodule ZkPortalWeb.LoginRegistry do
  use GenServer

  ## Client API

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def login(data) do
    GenServer.cast(__MODULE__, {:login, data})
  end

  def verify(token) do
    GenServer.call(__MODULE__, {:verify, token})
  end

  ## Server Callbacks
  # Server data is %{token => {user, expiration_time}}

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast({:login, {token, user}}, registry) do
    {_, updated_registry} = Map.get_and_update(registry, token, fn old_data ->
      case old_data do
        {old_user, expiration_time} ->
          # The user has previously logged in.  Update the expiration time.
          {old_data, {old_user, expiration_time}} # return the same thing for now
        nil ->
          # Add the user to the registry.
          {old_data, {user, "fake time"}}
      end
    end )
    {:noreply, updated_registry}
  end

  def handle_call({:verify, token}, _from, registry) do
    ret_value = case Map.fetch(registry, token) do
      {:ok, {user, _expiration_time}} ->
        {:ok, user}
      _ ->
        :error
    end
    {:reply, ret_value, registry}
  end
end

# Based on https://robots.thoughtbot.com/make-phoenix-even-faster-with-a-genserver-backed-key-value-store
defmodule ZkPortalWeb.LoginRegistry.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(ZkPortalWeb.LoginRegistry, [[name: ZkPortalWeb.LoginRegistry]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end