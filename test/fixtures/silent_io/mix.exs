defmodule SilentIo.MixProject do
  use Mix.Project

  def project do
    [
      app: :silent_io,
      version: "0.0.0"
    ]
  end

  def application do
    [
      extra_applications: [:lettuce]
    ]
  end
end
