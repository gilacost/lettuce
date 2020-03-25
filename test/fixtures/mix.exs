defmodule Project.Mixfile do
  use Mix.Project

  def project do
    [
      app: :project,
      apps_path: "apps",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod
    ]
  end

  def application do
    [
      extra_applications: [:lettuce, :logger]
    ]
  end
end
