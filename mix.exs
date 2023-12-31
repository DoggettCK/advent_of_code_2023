defmodule AdventOfCode2023.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent_of_code_2023,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {AOC.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cachex, "~> 3.6"},
      {:combination, "~> 0.0.3"},
      {:mix_test_watch, "~> 1.1", only: [:dev, :test], runtime: false}
    ]
  end
end
