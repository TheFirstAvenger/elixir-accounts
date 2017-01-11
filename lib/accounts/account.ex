require Logger

defmodule Accounts.Account do
  use GenServer

  def start_link(init_bal_fn \\ fn -> 0 end, upd_bal_fn \\ fn _,_ -> nil end) do
    GenServer.start_link(__MODULE__, {:ok, init_bal_fn, upd_bal_fn})
  end

  def get_balance(acct) do
    GenServer.call(acct, :get_balance)
  end

  def change_balance(acct, by_amount) do
    GenServer.call(acct, {:change_balance, by_amount})
  end

  ## Callbacks

  def init({:ok, init_bal_fn, upd_bal_fn}) do
    {:ok, {init_bal_fn.(), upd_bal_fn}}
  end

  def handle_call(:get_balance, _from, {balance, upd_bal_fn}) do
    {:reply, balance, {balance, upd_bal_fn}}
  end

  def handle_call({:change_balance, by_amount}, _from, {balance, upd_bal_fn}) do
    case balance + by_amount do
      x when x < 0 ->
        {:reply, {:error, :insufficient_funds}, {balance, upd_bal_fn}}
      x ->
        upd_bal_fn.(x)
        {:reply, {:ok, x}, {x, upd_bal_fn}}
    end
  end

end
