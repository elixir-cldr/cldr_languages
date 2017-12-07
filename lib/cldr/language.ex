defmodule Cldr.Language do
  @moduledoc """
  Cldr Languages does provide functionality regarding languages within the data
  supplied by the Cldr core package.
  """
  require Cldr
  alias Cldr.LanguageTag
  alias Cldr.Locale

  @type styles :: :standard | :short
  @styles [:standard, :short]

  @languages Cldr.default_locale
    |> Map.get(:cldr_locale_name)
    |> Cldr.Config.get_locale
    |> Map.get(:languages)

  @available_languages @languages |> Map.keys()

  @doc """
  Returns a list of the known languages.
  """
  @spec all_languages() :: list(String.t)
  def all_languages do
    @available_languages
  end

  @doc """
  Return a list of available translations for the given locale
  """
  @spec available_languages(String.t | LanguageTag.t) :: list(String.t) | {:error, term()}
  def available_languages(locale \\ Cldr.get_current_locale())
  def available_languages(%LanguageTag{cldr_locale_name: cldr_locale_name}) do
    available_languages(cldr_locale_name)
  end

  @doc """
  Return all the language translations for the given locale
  """
  @spec known_languages(String.t | LanguageTag.t) :: %{required(styles()) => String.t} | {:error, term()}
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

  @doc """
  Try to translate the given lanuage iso code or language tag.
  """
  @spec to_string(String.t | LanguageTag.t) :: {:ok, String.t} | {:error, term()}
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