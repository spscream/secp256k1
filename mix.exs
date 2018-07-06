defmodule Secp256k1.Mixfile do
  use Mix.Project

  def project do
    [
      app: :secp256k1,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package(),
      description: description()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: []
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end

  defp description do
    "secp256k1 implementation in Elixir"
  end

  defp package do
    [name: :secp256k1,
     files: ["lib", "mix.exs"],
     maintainers: ["Alexander Malaev"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/spscream/secp256k1"}]
  end
end
