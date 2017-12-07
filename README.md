# Cldr Languages

[ex_cldr_languages](https://github.com/LostKobrakai/cldr_languages) is an addon library application for [ex_cldr](https://hex.pm/packages/ex_cldr) that provides localization and listing of languages.

The primary api is Cldr.Language.to_string/2. The following examples demonstrate:

```elixir
iex> Cldr.Language.to_string "en-GB"
{:ok, "British English"}

iex> Cldr.Language.to_string "en-GB", style: :short
{:ok, "UK English"}

iex> Cldr.Language.to_string "en", locale: "de"
{:ok, "Englisch"}
```

## Installation

```elixir
def deps do
  [
    {:cldr_languages, "~> 0.1.0"}
  ]
end
```

