defmodule Lettuce.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: Lettuce.Supervisor]
    Supervisor.start_link([Lettuce], opts)
  end
end
