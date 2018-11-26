defmodule Cldr.Language do
  @moduledoc """
  Cldr Languages does provide functionality regarding languages within the data
  supplied by the Cldr core package.
  """
  alias Cldr.LanguageTag

  @type styles :: :standard | :short

  @doc """
  Returns a list of the languages' iso-codes listed for
  the `ex_cldr` default locale.

  ## Example

      => Cldr.Language.all_languages(TestBackend.Cldr)
      ["aa", "ab", "ace", "ach", "ada", "ady", "ae", "aeb", "af", "afh", "agq", "ain",
      "ak", "akk", "akz", "ale", "aln", "alt", "am", "an", "ang", "anp", "ar",
      "ar-001", "arc", "arn", "aro", "arp", "arq", "ars", "arw", "ary", "arz", "as",
      "asa", "ase", "ast", "av", "avk", "awa", "ay", "az", "ba", "bal", "ban", "bar",
      "bas", "bax", "bbc", "bbj", ...]

  """
  @spec all_languages(Cldr.backend()) :: list(String.t())
  def all_languages(backend) do
    module = Module.concat(backend, Language)
    module.all_languages()
  end

  @doc """
  Return all the languages' iso-codes available for a given locale.
  Defaults to the current locale.

  ## Example

      => Cldr.Language.available_languages("en", TestBackend.Cldr)
      ["aa", "ab", "ace", "ach", "ada", "ady", "ae", "aeb", "af", "afh", "agq", "ain",
      "ak", "akk", "akz", "ale", "aln", "alt", "am", "an", "ang", "anp", "ar",
      "ar-001", "arc", "arn", "aro", "arp", "arq", "ars", "arw", "ary", "arz", "as",
      "asa", "ase", "ast", "av", "avk", "awa", "ay", "az", "ba", "bal", "ban", "bar",
      "bas", "bax", "bbc", "bbj", ...]
  """
  @spec available_languages(String.t() | LanguageTag.t(), Cldr.backend()) :: list(String.t()) | {:error, term()}
  def available_languages(locale, backend) do
    module = Module.concat(backend, Language)
    module.available_languages(locale)
  end

  @doc """
  Return a map of iso-code keyed maps of language names in any available
  formats for the given locale.
  Defaults to the current locale.

  ## Example

      => Cldr.Language.known_languages("en", TestBackend.Cldr)
      %{
        "bez" => %{standard: "Bena"},
        "lo" => %{standard: "Lao"},
        "kha" => %{standard: "Khasi"},
        "eo" => %{standard: "Esperanto"},
        "rm" => %{standard: "Romansh"},
        "ja" => %{standard: "Japanese"},
        "sw-CD" => %{standard: "Congo Swahili"},
        "pdc" => %{standard: "Pennsylvania German"},
        "om" => %{standard: "Oromo"},
        "jut" => %{standard: "Jutish"},
        "lij" => %{standard: "Ligurian"},
        "kut" => %{standard: "Kutenai"},
        "vep" => %{standard: "Veps"},
        "yao" => %{standard: "Yao"},
        "gez" => %{standard: "Geez"},
        "cr" => %{standard: "Cree"},
        "ne" => %{standard: "Nepali"},
        "zbl" => %{standard: "Blissymbols"},
        "ae" => %{standard: "Avestan"},
        "rof" => %{standard: "Rombo"},
        "tkl" => %{standard: "Tokelau"},
        "rgn" => %{standard: "Romagnol"},
        "el" => %{standard: "Greek"},
        "myv" => %{standard: "Erzya"},
        "smj" => %{standard: "Lule Sami"},
        "fo" => %{standard: "Faroese"},
        "ii" => %{standard: "Sichuan Yi"},
        "bum" => %{standard: "Bulu"},
        "za" => %{standard: "Zhuang"},
        "raj" => %{standard: "Rajasthani"},
        "mrj" => %{standard: "Western Mari"},
        "stq" => %{standard: "Saterland Frisian"},
        "hu" => %{standard: "Hungarian"},
        "mga" => %{standard: "Middle Irish"},
        "bej" => %{standard: "Beja"},
        "yue" => %{standard: "Cantonese"},
        "xog" => %{standard: "Soga"},
        "ttt" => %{standard: "Muslim Tat"},
        "uga" => %{standard: "Ugaritic"},
        "rup" => %{standard: "Aromanian"},
        "crs" => %{standard: "Seselwa Creole French"},
        "oc" => %{standard: "Occitan"},
        "chp" => %{standard: "Chipewyan"},
        "zen" => %{standard: "Zenaga"},
        "kmb" => %{standard: "Kimbundu"},
        "nr" => %{standard: "South Ndebele"},
        "tiv" => %{standard: "Tiv"},
        "aln" => %{standard: "Gheg Albanian"},
        "sh" => %{standard: "Serbo-Croatian"},
        ...}
  """
  @spec known_languages(String.t() | LanguageTag.t(), Cldr.backend()) :: %{required(styles()) => String.t()} | {:error, term()}
  def known_languages(locale, backend) do
    module = Module.concat(backend, Language)
    module.known_languages(locale)
  end

  @doc """
  Try to translate the given lanuage iso code or language tag.

  ## Example

    iex> Cldr.Language.to_string("eo", TestBackend.Cldr)
    {:ok, "Esperanto"}
  """
  @spec to_string(String.t() | LanguageTag.t(), Cldr.backend(), keyword()) :: {:ok, String.t()} | {:error, term()}
  def to_string(key, backend, options \\ []) do
    module = Module.concat(backend, Language)
    module.to_string(key, options)
  end
end
