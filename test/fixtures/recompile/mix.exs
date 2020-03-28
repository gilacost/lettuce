defmodule Recompile.MixProject do
  use Mix.Project

  def project do
    [
      app: :recompile,
      version: "0.0.0"
    ]
  end

  def application do
    [
      extra_applications: [:lettuce]
    ]
  end
end
