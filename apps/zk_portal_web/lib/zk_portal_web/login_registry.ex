defmodule ZkPortalWeb.LoginRegistry do
  use GenServer

  ## Client API

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def login(server, data) do
    GenServer.cast(server, {:login, data})
  end

  def verify(server, token) do
    GenServer.call(server, {:verify, token})
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
        user
      _ ->
        nil
    end
    {:reply, ret_value, registry}
  end
end