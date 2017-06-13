# Accounts

Simple implementation of a multi-node account registry with thread-safe account balance retrieval and modification

# Usage

Console 1:
```shell
iex --sname foo -S mix
```
Console 2:

```shell
iex --sname bar -S mix
```
```elixir
Node.connect :'foo@youcomputername'
```
Console 1:

```elixir
{:ok, johns_account} = Accounts.Registry.get_account "john"
Accounts.Account.get_balance johns_account
Accounts.Account.change_balance johns_account, 5
Accounts.Account.get_balance johns_account
```

Console 2:

```elixir
{:ok, johns_account} = Accounts.Registry.get_account "john"
Accounts.Account.get_balance johns_account
Accounts.Account.change_balance johns_account, 5
Accounts.Account.get_balance johns_account
```
Console 1:

```elixir
Accounts.Account.get_balance johns_account
```
