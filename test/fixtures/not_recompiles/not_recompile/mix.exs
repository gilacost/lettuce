defmodule NotRecompiles.MixProject do
  use Mix.Project

  def project do
    [
      app: :not_recompiles,
      version: "0.0.0"
    ]
  end

  def application do
    [
      extra_applications: [:lettuce]
    ]
  end
end
