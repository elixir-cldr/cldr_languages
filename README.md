# Cldr Languages

[![Build Status](https://travis-ci.org/LostKobrakai/cldr_languages.svg?branch=master)](https://travis-ci.org/LostKobrakai/cldr_languages)
[![Coverage Status](https://coveralls.io/repos/github/LostKobrakai/cldr_languages/badge.svg)](https://coveralls.io/github/LostKobrakai/cldr_languages)
[![Hex.pm](https://img.shields.io/hexpm/v/ex_cldr_languages.svg)](https://hex.pm/packages/ex_cldr_languages)
[![Hex.pm](https://img.shields.io/hexpm/dw/ex_cldr_languages.svg?)](https://hex.pm/packages/ex_cldr_languages)
[![Hex.pm](https://img.shields.io/hexpm/l/ex_cldr_languages.svg)](https://hex.pm/packages/ex_cldr_languages)

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

