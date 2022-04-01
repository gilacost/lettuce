# Lettuce 🥬

<!-- MDOC -->

Lettuce is a generic server process that checks the files within an elixir
project that has lettuce as a dependency and then runs `iex -S mix`. It
initialises the state of the generic server with the `.ex` files inside `lib`
and their last modified time. By default `lib` is used but you may specify which
folders you want to be watched.

![Elixir CI status](https://github.com/gilacost/lettuce/workflows/Elixir%20CI/badge.svg)&nbsp;[![Hex version badge](https://img.shields.io/hexpm/v/lettuce.svg)](https://hex.pm/packages/lettuce)&nbsp;[![codecov](https://codecov.io/gh/gilacost/lettuce/branch/master/graph/badge.svg)](https://codecov.io/gh/gilacost/lettuce)![](/priv/lettuce.jpg)

## Configuration example

```elixir
use Mix.Config

config :lettuce, folders_to_watch: ["apps"]
...
```

You can also change the refresh time to control how often the project files
will be checked.

```elixir
use Mix.Config

config :lettuce, refresh_time: 1500
...

```

Even though the `start_link` will throw an error if the `Mix.env` equals to
`:dev` it is recommended to explicitly select the extra applications by
environment in the mix file.

```elixir
...
def application do
  [
    extra_applications: extra_applications(Mix.env(), [:logger, ...])
  ]
end

defp extra_applications(:dev, default), do: default ++ [:lettuce]
defp extra_applications(_, default), do: default
...
```

### Mix compiler task options

You might send special parameters to the compiler task that lettuce runs. This
is not required. In your project of parameters in config.exs:

```elixir

config :lettuce,
  folders_to_watch: ["lib"],
  compiler_opts: [
    "--ignore-module-conflict",
    "--verbose"
  ]
```

For the available options check the [Mix.Tasks.Compile.Elixir](https://github.com/elixir-lang/elixir/blob/v1.1.1/lib/mix/lib/mix/tasks/compile.elixir.ex#L1) docs.

<!-- MDOC -->

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `lettuce` to your list of dependencies in `mix.exs`:

```elixir
...
def deps do
  [
    {:lettuce, "~> 0.2.0", only: :dev}
  ]
end
...
```

## Inspiration

While giving Node.js lessons as part of a charity called [MigraCode](https://migracode.eu/)
in El Borne, Barcelona. We were reviewing some exercises and one of the steps in
the instructions was to npm install nodemon, which reminded me of all the times
I was inside IEx debbuging and I had to call recompile.

## Author

Josep Lluis Giralt D'Lacoste.

## License

Lettuce is released under the MIT License. See the LICENSE file for further
details.
