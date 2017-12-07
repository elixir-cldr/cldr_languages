defmodule Cldr.Language do
  require Cldr
  alias Cldr.LanguageTag
  alias Cldr.Locale

  @styles [:standard, :short]

  @languages Cldr.default_locale
    |> Map.get(:cldr_locale_name)
    |> Cldr.Config.get_locale
    |> Map.get(:languages)
  @available_languages @languages |> Map.keys()

  @doc """
  Returns a list of the known unit categories.
  ## Example
      [:acceleration, :angle, :area, :concentr, :consumption, :coordinate, :digital,
      :duration, :electric, :energy, :frequency, :length, :light, :mass, :power,
      :pressure, :speed, :temperature, :volume]
  """
  def all_languages do
    @available_languages
  end

  @doc """
  """
  @spec available_languages(String.t | LanguageTag.t) :: list(atom) | {:error, {Exeption.t, String.t}}
  def available_languages(locale \\ Cldr.get_current_locale())
  def available_languages(%LanguageTag{cldr_locale_name: cldr_locale_name}) do
    available_languages(cldr_locale_name)
  end

  @doc """
  """
  @spec known_languages(String.t | LanguageTag.t) :: map | {:error, {Exeption.t, String.t}}
  def known_languages(locale \\ Cldr.get_current_locale())
  def known_languages(%LanguageTag{cldr_locale_name: cldr_locale_name}) do
    known_languages(cldr_locale_name)
  end

  for locale_name <- Cldr.Config.known_locale_names() do
    languages = locale_name |> Cldr.Config.get_locale() |> Map.get(:languages)

    def available_languages(unquote(locale_name)) do
      unquote(Map.keys languages) |> Enum.sort
    end

    def known_languages(unquote(locale_name)) do
      unquote(Macro.escape(languages))
    end
  end

  def available_languages(locale), do: {:error, Locale.locale_error(locale)}
  
  def known_languages(locale), do: {:error, Locale.locale_error(locale)}

  def to_string(key, options \\ []) do
    %{locale: locale, style: style} = Keyword.merge(default_options(), options) |> Enum.into(%{})

    with {:ok, lang} <- locale |> known_languages |> Map.fetch(key) do
      case Map.fetch(lang, style) do
        {:ok, _} = val -> val
        :error -> Map.fetch(lang, :standard)
      end
    end
  end

  defp default_options do
    [
      style: :standard,
      locale: Cldr.get_current_locale()
    ]
  end
end