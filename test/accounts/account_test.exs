defmodule Accounts.AccountTest do
  use ExUnit.Case
  alias Accounts.Account

  doctest Account

  test "creates account" do
      {:ok, account} = Account.start_link
      assert is_pid(account)
  end

end
