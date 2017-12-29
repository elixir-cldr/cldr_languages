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

  @doc """
  Returns a list of the languages' iso-codes listed for 
  the `ex_cldr` default locale.

  ## Example

      > Cldr.Language.all_languages()
      ["aa", "ab", "ace", "ach", "ada", "ady", "ae", "aeb", "af", "afh", "agq", "ain",
      "ak", "akk", "akz", "ale", "aln", "alt", "am", "an", "ang", "anp", "ar",
      "ar-001", "arc", "arn", "aro", "arp", "arq", "ars", "arw", "ary", "arz", "as",
      "asa", "ase", "ast", "av", "avk", "awa", "ay", "az", "ba", "bal", "ban", "bar",
      "bas", "bax", "bbc", "bbj", ...]

  """
  @spec all_languages() :: list(String.t)
  def all_languages do
    available_languages(Cldr.default_locale)
  end

  @doc """
  Return all the languages' iso-codes available for a given locale.
  Defaults to the current locale.

  ## Example

      > Cldr.Language.available_languages("en")
      ["aa", "ab", "ace", "ach", "ada", "ady", "ae", "aeb", "af", "afh", "agq", "ain",
      "ak", "akk", "akz", "ale", "aln", "alt", "am", "an", "ang", "anp", "ar",
      "ar-001", "arc", "arn", "aro", "arp", "arq", "ars", "arw", "ary", "arz", "as",
      "asa", "ase", "ast", "av", "avk", "awa", "ay", "az", "ba", "bal", "ban", "bar",
      "bas", "bax", "bbc", "bbj", ...]
  """
  @spec available_languages(String.t | LanguageTag.t) :: list(String.t) | {:error, term()}
  def available_languages(locale \\ Cldr.get_current_locale())
  def available_languages(%LanguageTag{cldr_locale_name: cldr_locale_name}) do
    available_languages(cldr_locale_name)
  end

  @doc """
  Return a map of iso-code keyed maps of language names in any available 
  formats for the given locale.
  Defaults to the current locale.

  ## Example

      > Cldr.Language.known_languages("en")
      %{"bez" => %{standard: "Bena"}, "lo" => %{standard: "Lao"},
      "kha" => %{standard: "Khasi"}, "eo" => %{standard: "Esperanto"},
      "rm" => %{standard: "Romansh"}, "ja" => %{standard: "Japanese"},
      "sw-CD" => %{standard: "Congo Swahili"},
      "pdc" => %{standard: "Pennsylvania German"}, "om" => %{standard: "Oromo"},
      "jut" => %{standard: "Jutish"}, "lij" => %{standard: "Ligurian"},
      "kut" => %{standard: "Kutenai"}, "vep" => %{standard: "Veps"},
      "yao" => %{standard: "Yao"}, "gez" => %{standard: "Geez"},
      "cr" => %{standard: "Cree"}, "ne" => %{standard: "Nepali"},
      "zbl" => %{standard: "Blissymbols"}, "ae" => %{standard: "Avestan"},
      "rof" => %{standard: "Rombo"}, "tkl" => %{standard: "Tokelau"},
      "rgn" => %{standard: "Romagnol"}, "el" => %{standard: "Greek"},
      "myv" => %{standard: "Erzya"}, "smj" => %{standard: "Lule Sami"},
      "fo" => %{standard: "Faroese"}, "ii" => %{standard: "Sichuan Yi"},
      "bum" => %{standard: "Bulu"}, "za" => %{standard: "Zhuang"},
      "raj" => %{standard: "Rajasthani"}, "mrj" => %{standard: "Western Mari"},
      "stq" => %{standard: "Saterland Frisian"}, "hu" => %{standard: "Hungarian"},
      "mga" => %{standard: "Middle Irish"}, "bej" => %{standard: "Beja"},
      "yue" => %{standard: "Cantonese"}, "xog" => %{standard: "Soga"},
      "ttt" => %{standard: "Muslim Tat"}, "uga" => %{standard: "Ugaritic"},
      "rup" => %{standard: "Aromanian"},
      "crs" => %{standard: "Seselwa Creole French"}, "oc" => %{standard: "Occitan"},
      "chp" => %{standard: "Chipewyan"}, "zen" => %{standard: "Zenaga"},
      "kmb" => %{standard: "Kimbundu"}, "nr" => %{standard: "South Ndebele"},
      "tiv" => %{standard: "Tiv"}, "aln" => %{standard: "Gheg Albanian"},
      "sh" => %{standard: "Serbo-Croatian"}, "fil" => %{...}, ...}
  """
  @spec known_languages(String.t | LanguageTag.t) :: %{required(styles()) => String.t} | {:error, term()}
  def known_languages(locale \\ Cldr.get_current_locale())
  def known_languages(%LanguageTag{cldr_locale_name: cldr_locale_name}) do
    known_languages(cldr_locale_name)
  end

  # Implement available_locales/known_locales
  for locale_name <- Cldr.Config.known_locale_names() do
    languages = locale_name |> Cldr.Config.get_locale() |> Map.get(:languages)

    def available_languages(unquote(locale_name)) do
      unquote(Map.keys languages) |> Enum.sort
    end

    def known_languages(unquote(locale_name)) do
      unquote(Macro.escape(languages))
    end
  end

  # Error cases for available_locales/known_locales
  def available_languages(locale), do: {:error, Locale.locale_error(locale)}
  
  def known_languages(locale), do: {:error, Locale.locale_error(locale)}

  @doc """
  Try to translate the given lanuage iso code or language tag.
  """
  @spec to_string(String.t | LanguageTag.t) :: {:ok, String.t} | {:error, term()}
  def to_string(key, options \\ []) do
    opts = 
      %{}
      |> merge_style(options[:style])
      |> merge_locale(options[:locale])
      |> merge_fallback(options[:fallback])
    
    result = to_string_by_locale(key, opts.locale, opts)

    if result == :error && Map.get(opts, :fallback, false) do
      to_string_by_locale(key, Cldr.default_locale, opts)
    else
      result
    end
  end

  defp default_options do
    [
      style: :standard,
      locale: Cldr.get_current_locale(),
      fallback: false
    ]
  end

  defp to_string_by_locale(key, locale, %{style: style}) do
    with {:ok, lang} <- locale |> known_languages |> Map.fetch(key) do
      case Map.fetch(lang, style) do
        {:ok, _} = val -> val
        :error -> Map.fetch(lang, :standard)
      end
    end
  end

  defp merge_style(opts, nil), do: Map.put(opts, :style, :standard)
  defp merge_style(opts, style) when style in @styles, do: Map.put(opts, :style, style)
  defp merge_style(opts, style) do
    msg = 
      "Invalid :style  option #{inspect style} supplied. " <>
      "Valid styles are #{inspect @styles}."
    raise ArgumentError, msg
  end

  defp merge_locale(opts, nil), do: Map.put(opts, :locale, Cldr.get_current_locale())
  defp merge_locale(opts, locale), do: Map.put(opts, :locale, locale)

  defp merge_fallback(opts, nil), do: Map.put(opts, :fallback, false)
  defp merge_fallback(opts, fallback) when is_boolean(fallback), do: Map.put(opts, :fallback, fallback)
  defp merge_fallback(opts, fallback) do
    msg = 
      "Invalid :fallback  option #{inspect fallback} supplied. " <>
      "Valid fallbacks are #{inspect [true, false]}."
    raise ArgumentError, msg
  end
end