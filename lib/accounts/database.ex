defmodule Accounts.Database do
  use GenServer
  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def get_balance(account_name) do
    GenServer.call(__MODULE__, {:get_balance, account_name})
  end

  def update_balance(account_name, new_balance) do
    GenServer.call(__MODULE__, {:update_balance, account_name, new_balance})
  end

  #GenServer Callbacks

  def init(:ok) do
    {:ok, conn} = Mongo.start_link(database: "account_test")
    Logger.info "MongoDB started"
    {:ok, conn}
  end

  def handle_call({:get_balance, account_name}, _from, conn) do
    conn
    |> Mongo.find("account", %{"name" => account_name})
    |> Enum.to_list
    |> case do
      [acct] ->
        {:reply, acct["balance"], conn}
      [] ->
        {:reply, 0, conn}
    end
  end

  def handle_call({:update_balance, account_name, new_balance}, _from, conn) do
    Mongo.update_one!(conn, "account", %{"name" => account_name}, %{"$set": %{"balance" => new_balance}}, [upsert: true])
    {:reply, :ok, conn}
  end

end
