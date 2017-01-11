require Logger

defmodule Accounts.Registry do
  use GenServer

  @name {:global, __MODULE__}

  def start_link(init_bal_fn \\ fn _ -> 0 end, upd_bal_fn \\ fn _,_ -> nil end) do
    case GenServer.start_link(__MODULE__, {%{}, init_bal_fn, upd_bal_fn}, name: @name) do
      {:ok, pid} ->
        Logger.info "Started #{__MODULE__} master"
        {:ok, pid}
      {:error, {:already_started, pid}} ->
        Logger.info "Started #{__MODULE__} slave"
        {:ok, pid}
    end
  end

  def get_account(name) do
    GenServer.call(@name, {:get, name})
  end

  def clear_accounts do
    GenServer.call(@name, :clear_accounts)
  end

  # GenServer Callbacks

  def handle_call({:get, account_name}, _from, {accounts, init_bal_fn, upd_bal_fn}) do
    accounts
    |> Map.get(account_name)
    |> case do
      nil ->
        {:ok, account} = Accounts.Account.start_link(fn -> init_bal_fn.(account_name) end, fn new_bal -> upd_bal_fn.(account_name, new_bal) end)
        {:reply, {:ok, account}, {Map.put(accounts, account_name, account), init_bal_fn, upd_bal_fn}}
      account ->
        {:reply, {:ok, account}, {accounts, init_bal_fn, upd_bal_fn}}
    end
  end

  def handle_call(:clear_accounts, _from, {_accounts, init_bal_fn, upd_bal_fn}) do
    {:reply, :ok, {%{}, init_bal_fn, upd_bal_fn}}
  end

end
