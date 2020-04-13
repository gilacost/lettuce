defmodule CompilerOpts.MixProject do
  use Mix.Project

  def project do
    [
      app: :compiler_opts,
      version: "0.0.0"
    ]
  end

  def application do
    [
      extra_applications: [:lettuce]
    ]
  end
end
