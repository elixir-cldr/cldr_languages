# Cldr Languages

[![Hex.pm](https://img.shields.io/hexpm/v/ex_cldr_languages.svg)](https://hex.pm/packages/ex_cldr_languages)
[![Hex.pm](https://img.shields.io/hexpm/dw/ex_cldr_languages.svg?)](https://hex.pm/packages/ex_cldr_languages)
[![Hex.pm](https://img.shields.io/hexpm/l/ex_cldr_languages.svg)](https://hex.pm/packages/ex_cldr_languages)

[ex_cldr_languages](https://github.com/elixir-cldr/cldr_languages) is an addon library application for [ex_cldr](https://hex.pm/packages/ex_cldr) that provides localization and listing of languages.

## Installation

Add `:ex_cldr_languages` to your `deps`:

```elixir
def deps do
  [
    {:ex_cldr_languages, "~> 0.3.0"}
  ]
end
```

Then register `Cldr.Language` as a provider in your Cldr backend module (see the [`ex_cldr` setup instructions](https://hexdocs.pm/ex_cldr/readme.html#introduction) for the backend itself):

```elixir
defmodule MyApp.Cldr do
  use Cldr,
    locales: ["en", "de", "fr"],
    default_locale: "en",
    providers: [Cldr.Language]
end
```

The library's functionality is then available on `MyApp.Cldr.Language`:

```elixir
iex> MyApp.Cldr.Language.to_string "en-GB"
{:ok, "British English"}

iex> MyApp.Cldr.Language.to_string "en-GB", style: :short
{:ok, "UK English"}

iex> MyApp.Cldr.Language.to_string "en", locale: "de"
{:ok, "Englisch"}
```

The `MyApp.Cldr` module name above is the conventional placeholder used throughout the `ex_cldr` ecosystem. Substitute your own backend module name if you've chosen a different one.

## Migration from v0.1.1 to v0.2.0

With the switch to `ex_cldr` v2 any functionality is now called via `MyApp.Cldr.Language` (the language provider compiled into your Cldr backend) instead of the top-level `Cldr.Language` module. This breaking change was also used to remove `all_languages/0` in favor of `available_languages/0`.