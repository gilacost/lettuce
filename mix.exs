defmodule Lettuce.MixProject do
  use Mix.Project

  def project do
    [
      app: :lettuce,
      version: "0.2.0",
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      dialyzer: dialyzer(),
      test_coverage: test_coverage(),
      preferred_cli_env: preferred_cli_env(),
      description:
        "Lettuce checks the files within an elixir project and then runs `iex -S mix`. It initialises the state of a generic server with the `.ex` files inside `lib` and their last modified time. By default `lib` is used but you can specify which folders you want to be watched.",
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
    ]
  end

  defp dialyzer() do
    [
      plt_add_deps: [:apps_direct],
      plt_add_apps: [:mix],
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
    ]
  end

  defp test_coverage do
    [
      tool: ExCoveralls
    ]
  end

  defp preferred_cli_env do
    [
      "coveralls.detail": :test,
      "coveralls.html": :test,
      "coveralls.json": :test,
      coveralls: :test
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
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:excoveralls, "~> 0.14.4", only: :test},
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
