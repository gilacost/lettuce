defmodule Lettuce do
  @moduledoc """

  Lettuce is a generic server process that checks the files within an elixir
  project that has lettuce as a dependency and then runs `iex -S mix`. It
  initialises the state gen server with the `.ex` files inside `lib` and their
  last modified time. By default `lib` is used but you specify which folders you
  want to be watched.

  ## Configuration example

      use Mix.Config

      config :lettuce, folders_to_watch: ["apps"]
      ..

  You can also change the refresh time to control how often the project files
  will be checked.

      use Mix.Config

      config :lettuce, refresh_time: 1500
      ..

  Even though the `start_link` will throw an error if the `Mix.env` equals to
  `:dev` it is recommended to explicitly select the extra applications by
  environment in the mix file.

      def application do
        [
          extra_applications: extra_applications(Mix.env(), [:logger, ...])
        ]
      end

      defp extra_applications(:dev, default), do: default ++ [:lettuce]
      defp extra_applications(_, default), do: default

  """
  require Logger
  use GenServer
  alias Lettuce.Config

  @refresh_time Config.refresh_time()

  @doc false
  @spec start_link(list) :: {:ok, pid} | {:error, term}
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  # Server (callbacks)

  @impl true
  def init(_) do
    Logger.info("current directory: #{File.cwd!()}")
    Logger.info("watching folders: #{inspect(Config.folders_to_watch())}")
    schedule_check()
    {:ok, project_files()}
  end

  @impl true
  def handle_info(:project_review, state) do
    state
    |> List.myers_difference(project_files())
    |> length()
    |> restart_system()

    schedule_check()
    {:noreply, state}
  end

  defp schedule_check(), do: Process.send_after(self(), :project_review, @refresh_time)

  defp restart_system(len) when len != 1 do
    Logger.info("System being restarted...")
    System.restart()
  end

  defp restart_system(_), do: nil

  defp project_files() do
    Enum.map(Config.folders_to_watch(), &folder_files/1)
  end

  defp folder_files(folder) do
    "#{File.cwd!()}/#{folder}/**/*.ex"
    |> Path.wildcard()
    |> Enum.map(&put_mtime/1)
  end

  defp put_mtime(file) do
    %File.Stat{mtime: mtime} = File.lstat!(file)
    {file, mtime}
  end
end
