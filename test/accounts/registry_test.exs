defmodule Accounts.RegistryTest do
  use ExUnit.Case
  doctest Accounts

  setup do
    on_exit fn ->
      Accounts.Registry.clear_accounts
    end
    :ok
  end

  test "clears accounts" do
    {:ok, account1} = Accounts.Registry.get_account("clears account")
    Accounts.Registry.clear_accounts
    {:ok, account2} = Accounts.Registry.get_account("clears account")
    refute account1 == account2
  end

  test "gets account" do
    {:ok, account} = Accounts.Registry.get_account("gets account")
    assert is_pid account
  end

  test "gets same account" do
    {:ok, account1} = Accounts.Registry.get_account("gets same account")
    {:ok, account2} = Accounts.Registry.get_account("gets same account")
    assert account1 == account2
  end

  test "gets different account" do
    {:ok, account1} = Accounts.Registry.get_account("gets different account1")
    {:ok, account2} = Accounts.Registry.get_account("gets different account2")
    refute account1 == account2
  end

end
