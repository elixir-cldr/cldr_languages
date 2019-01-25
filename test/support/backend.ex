defmodule Cldr.Language.TestBackend do
  # Needed only for local usage.
  # For usage in dependencies the module will be ensured to be ready
  require Cldr.Language

  use Cldr,
    default_locale: "en-001",
    locales: ["en-001", "en", "de"],
    providers: [Cldr.Language]
end
