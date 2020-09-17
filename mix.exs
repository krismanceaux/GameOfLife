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
        "Life is a lightweight package for Conway's Game of Life that takes in a set of live cells and returns the next generation. The new generation is stored as the state in a GenServer process in the GameServer module. This package leaves it up to the interface, whether it's the console or a web framework, to determine how to continue producing new generations and displaying them to the user. This package comes with a simple Console interface as an example. Instructions for using the console interface are in the README.",
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/krismanceaux/GameOfLife",
        "GitLab" => "https://gitlab.com/kristophermanceaux/gameoflife"
      },
      maintainers: ["Kristopher Manceaux"],
      source_url: "https://gitlab.com/kristophermanceaux/gameoflife"
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
end
