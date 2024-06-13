# Cldr Languages

[![Hex.pm](https://img.shields.io/hexpm/v/ex_cldr_languages.svg)](https://hex.pm/packages/ex_cldr_languages)
[![Hex.pm](https://img.shields.io/hexpm/dw/ex_cldr_languages.svg?)](https://hex.pm/packages/ex_cldr_languages)
[![Hex.pm](https://img.shields.io/hexpm/l/ex_cldr_languages.svg)](https://hex.pm/packages/ex_cldr_languages)

[ex_cldr_languages](https://github.com/elixir-cldr/cldr_languages) is an addon library application for [ex_cldr](https://hex.pm/packages/ex_cldr) that provides localization and listing of languages.

The primary api is `MyApp.Backend.Language.to_string/2`. The following examples demonstrate:

```elixir
iex> MyApp.Backend.Language.to_string "en-GB"
{:ok, "British English"}

iex> MyApp.Backend.Language.to_string "en-GB", style: :short
{:ok, "UK English"}

iex> MyApp.Backend.Language.to_string "en", locale: "de"
{:ok, "Englisch"}
```

## Installation

```elixir
def deps do
  [
    {:ex_cldr_languages, "~> 0.3.0"}
  ]
end
```

## Migration from v0.1.1 to v0.2.0

With the switch to `ex_cldr` v2 any functionality is now to be called via `MyApp.Backend.Language` instead of `Cldr.Language`. This breaking change was 
also used to remove `all_languages/0` in favor of `available_languages/0`.