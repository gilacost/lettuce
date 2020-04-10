defmodule Lettuce.Config do
  @moduledoc """
  Access the configuration parameters defined at project level.

  """

  @doc """
  The time that lettuce will wait until project files reviews.

  ## Examples:

      iex> Lettuce.Config.refresh_time()
      1000

  """
  @spec refresh_time() :: String.t()
  def refresh_time() do
    Application.get_env(:lettuce, :refresh_time, 1000)
  end

  @doc """
  List of folders from current project whose freshness will be checked.

  ## Examples:

      iex> Lettuce.Config.folders_to_watch()
      ["lib"]

  """
  @spec folders_to_watch() :: String.t() | nil
  def folders_to_watch() do
    Application.get_env(:lettuce, :folders_to_watch, ["lib"])
  end

  @doc """
  Enables the output that lettuce generates to be able to check that is working.
  This is enabled by default.

  """
  @spec silent?() :: String.t() | nil
  def silent?() do
    Application.get_env(:lettuce, :silent?, false)
  end

  defmodule Compiler do
    defstruct verbose: :boolean,
              force: :boolean,
              ignore_module_conflict: :boolean,
              warnings_as_conflict: :boolean,
              elixirc_paths: :list

    def options() do
      Application.get_env(:lettuce, :compiler_opts, ["--verbose"])
    end

    def validations() do
      %__MODULE__{} |> Map.from_struct() |> Map.to_list()
    end
  end
end
