# Accounts

Simple implementation of a multi-node account registry with thread-safe account balance retrieval and modification

# Usage

Console 1:

iex --sname foo -S mix

Console 2:

iex --sname bar -S mix
Node.connect :'foo@youcomputername'

Console 1:

{:ok, johns_account} = Accounts.Registry.get_account "john"
Accounts.Account.get_balance johns_account
Accounts.Account.change_balance johns_account, 5
Accounts.Account.get_balance johns_account

Console 2:

{:ok, johns_account} = Accounts.Registry.get_account "john"
Accounts.Account.get_balance johns_account
Accounts.Account.change_balance johns_account, 5
Accounts.Account.get_balance johns_account

Console 1:

Accounts.Account.get_balance johns_account
