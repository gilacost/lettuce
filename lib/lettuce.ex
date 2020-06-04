defmodule Lettuce do
  @moduledoc "README.md"
             |> File.read!()
             |> String.split("<!-- MDOC -->")
             |> Enum.fetch!(1)

  use GenServer
  require Logger

  alias Lettuce.Config
  alias Mix.Tasks.Compile.Elixir, as: Compiler

  @refresh_time Config.refresh_time()
  @opts Config.Compiler.options()

  @doc false
  @spec start_link(list) :: {:ok, pid} | {:error, term}
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  # Server (callbacks)

  @impl true
  def init(_) do
    unless Config.silent?() do
      Logger.info("current directory: #{File.cwd!()}")
      Logger.info("watching folders: #{inspect(Config.folders_to_watch())}")
    end

    schedule_check()
    {:ok, project_files()}
  end

  @impl true
  def handle_info(:project_review, state) do
    new_state =
      state
      |> List.myers_difference(project_files())
      |> length()
      |> recompile()

    schedule_check()
    {:noreply, new_state}
  end

  @spec schedule_check :: reference
  defp schedule_check(), do: Process.send_after(self(), :project_review, @refresh_time)

  @spec recompile(integer) :: [String.t()]
  defp recompile(len) when len != 1 do
    unless Config.silent?() do
      Logger.info("recompiling...")
    end

    Compiler.run(@opts)
    project_files()
  end

  defp recompile(_), do: project_files()

  @spec project_files() :: [String.t()]
  defp project_files() do
    Enum.map(Config.folders_to_watch(), &folder_files/1)
  end

  @type file_last_modified :: {String.t(), File.erlang_time()}

  @spec folder_files(String.t()) :: [file_last_modified]
  defp folder_files(folder) do
    "#{File.cwd!()}/#{folder}/**/*.ex"
    |> Path.wildcard()
    |> Enum.map(&put_mtime/1)
  end

  @spec put_mtime(String.t()) :: file_last_modified
  defp put_mtime(file) do
    %File.Stat{mtime: mtime} = File.lstat!(file)
    {file, mtime}
  end
end
