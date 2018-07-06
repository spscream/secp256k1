# Secp256k1

Library providing secp256k1 curve operations. Using this library you can:
- apply scalar multiplication to point(this operation used in Bitcoin private to public keys mapping)
- add two points

This code based on source code from answer:
* https://bitcoin.stackexchange.com/questions/25024/how-do-you-get-a-bitcoin-public-key-from-a-private-key

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `secp256k1` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:secp256k1, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/secp256k1](https://hexdocs.pm/secp256k1).

