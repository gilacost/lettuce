defmodule Lettuce.MixProject do
  use Mix.Project

  def project do
    [
      app: :lettuce,
      version: "0.1.4",
      elixir: "~> 1.10.2",
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      deps: deps(),
      description: """
      Lettuce checks the files within an elixir project and then runs `iex -S mix`. It initialises the state of a
      generic server with the `.ex` files inside `lib` and their last modified
      time. By default `lib` is used but you can specify which folders you want to
      be watched.
      """,
      package: package(),
      dialyzer: [
        plt_add_deps: [:apps_direct],
        plt_add_apps: [:mix],
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ],
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Lettuce.Application, []}
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0.0-rc.7", only: [:dev, :test], runtime: false}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Josep Lluis Giralt D'Lacoste"],
      licenses: ["MIT License"],
      links: %{"GitHub" => "https://github.com/gilacost/lettuce"}
    ]
  end
end
