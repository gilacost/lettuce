# Lettuce 🥬

Lettuce is a generic server process that checks the files within an elixir
project that has lettuce as a dependency and then runs `iex -S mix`. It
initialises the state of the generic server with the `.ex` files inside `lib`
and their last modified time. By default `lib` is used but you may specify which
folders you want to be watched.

![Elixir CI status](https://github.com/gilacost/lettuce/workflows/Elixir%20CI/badge.svg)&nbsp;![Hex version badge](https://img.shields.io/hexpm/v/lettuce.svg)&nbsp;[![codecov](https://codecov.io/gh/gilacost/lettuce/branch/master/graph/badge.svg)](https://codecov.io/gh/gilacost/lettuce)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `lettuce` to your list of dependencies in `mix.exs`:

```elixir
...
def deps do
  [
    {:lettuce, "~> 0.1.0", only: :dev}
  ]
end
...
```
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

## Todo

- [x] test everything
- [x] dialyzer
- [x] erlang time type for dyalizer
- [x] caching plts in github actions
- [x] pass the initial time from the setup to fix the flaky test
- [x] capture log with silent
- [x] remove redefined module warning
- [x] code coverage
- [ ] all elixir run parameters as options
- [ ] use option parser
- [ ] package publishing when tagging
- [ ] how it works
