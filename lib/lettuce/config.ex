defmodule Lettuce.Config do
  @moduledoc """
  Access the configuration parameters defined at project level.

  """

  @doc """
  The time that lettuce will wait until next project files modified time review.

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
  Enables the output that lettuce produces for debugging purposes..
  This is enabled by default.

  """
  @spec silent?() :: String.t() | nil
  def silent?() do
    Application.get_env(:lettuce, :silent?, false)
  end

  defmodule Compiler do
    @moduledoc """
    This module defines the struct of options that are accepted by the
    [Mix.Tasks.Compile.Elixir](https://github.com/elixir-lang/elixir/blob/v1.1.1/lib/mix/lib/mix/tasks/compile.elixir.ex#L1),
    for more information find the docs [here](https://hexdocs.pm/mix/1.1.1/Mix.Tasks.Compile.Elixir.html).

    *NOTE*: --ignore-module-conflict is a requirement.

    ## Example of parameters in config.exs:

        compiler_opts: [
          "--ignore-module-conflict",
          "--docs"
        ]

    """

    @default ["--verbose", "--ignore-module-conflict"]

    defstruct verbose: :boolean,
              force: :boolean,
              docs: :boolean,
              no_docs: :boolean,
              debug_info: :boolean,
              no_debug_info: :boolean,
              ignore_module_conflict: :boolean,
              warnings_as_errors: :boolean

    @doc """
    Options tries to validate the parameters defined in `config.exs`. It will
    throw and exception if a parameter is invalid. Parsed parameters are 
    ignored because the options are forwarded as strings to 
    `Mix.Tass.Compile.Elixir`.

    """
    @spec options() :: [String.t()] | no_return
    def options() do
      opts = Application.get_env(:lettuce, :compiler_opts, @default)
      {_parsed, _arg} = OptionParser.parse!(opts, strict: validations())

      opts
    end

    @doc """
    Returns the validations defined in the module struct as a keyword because
    that is whet the [OptionParser](https://hexdocs.pm/elixir/OptionParser.html)
    expects.

    """
    @spec validations() :: keyword
    def validations(), do: %__MODULE__{} |> Map.from_struct() |> Map.to_list()
  end
end
