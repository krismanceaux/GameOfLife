defmodule Life.MixProject do
  use Mix.Project

  def project do
    [
      app: :life,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description:
        "Life is a lightweight package for Conway's Game of Life that takes in a set of live cells and returns the next generation.",
      source_url: "https://gitlab.com/kristophermanceaux/gameoflife",
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp package do
    [
      maintainers: ["Kristopher Manceaux"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/krismanceaux/GameOfLife",
        "GitLab" => "https://gitlab.com/kristophermanceaux/gameoflife"
      }
    ]
  end
end
