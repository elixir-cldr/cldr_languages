defmodule Cldr.Language do
  @moduledoc """
  Cldr Languages does provide functionality regarding languages within the data
  supplied by the Cldr core package.

  To use the functionality of this module you need to [register it as provider](https://github.com/kipcole9/cldr#providers) in your cldr backend module.

  ## Example

      defmodule MyApp.Backend do
        use Cldr,
          providers: [Cldr.Language, …],
          …
      end

  ## Interface

  All functionality will be compiled into `MyApp.Backend.Language`.

  ### Functions

  * `available_languages/0`
  * `available_languages/1`
  * `known_languages/0`
  * `known_languages/1`
  * `to_string/1`
  * `to_string/2`

  """

  # This is only meant to be called by Cldr
  @doc false
  def cldr_backend_provider(config) do
    module = inspect(__MODULE__)
    backend = config.backend
    config = Macro.escape(config)

    quote location: :keep,
          bind_quoted: [
            module: module,
            backend: backend,
            config: config
          ] do
      defmodule Language do
        alias Cldr.LanguageTag
        alias Cldr.Locale

        @type styles :: :standard | :short
        @styles [:standard, :short]

        # Simpler than unquoting the backend everywhere
        defp backend, do: unquote(backend)
        defp get_locale, do: backend().get_locale()
        defp default_locale, do: backend().default_locale()

        @doc """
        Return all the languages' iso-codes available for a given locale.
        Defaults to the current locale.

        ## Example

            > #{inspect(__MODULE__)}.Language.available_languages(:en)
            ["aa", "ab", "ace", "ach", "ada", "ady", "ae", "aeb", "af", "afh", "agq", "ain",
            "ak", "akk", "akz", "ale", "aln", "alt", "am", "an", "ang", "anp", "ar",
            "ar-001", "arc", "arn", "aro", "arp", "arq", "ars", "arw", "ary", "arz", "as",
            "asa", "ase", "ast", "av", "avk", "awa", "ay", "az", "ba", "bal", "ban", "bar",
            "bas", "bax", "bbc", "bbj", ...]
        """
        @spec available_languages() :: list(String.t()) | {:error, term()}
        @spec available_languages(Locale.locale_name() | LanguageTag.t()) ::
                list(String.t()) | {:error, term()}
        def available_languages(locale \\ get_locale())

        def available_languages(%LanguageTag{cldr_locale_name: cldr_locale_name}) do
          available_languages(cldr_locale_name)
        end

        @doc """
        Return a map of iso-code keyed maps of language names in any available
        formats for the given locale.
        Defaults to the current locale.

        ## Example

            > #{inspect(__MODULE__)}.Language.known_languages(:en)
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
        @spec known_languages() ::
                %{String.t() => %{required(styles()) => String.t()}} | {:error, term()}
        @spec known_languages(Locale.locale_name() | LanguageTag.t()) ::
                %{String.t() => %{required(styles()) => String.t()}} | {:error, term()}
        def known_languages(locale \\ get_locale())

        def known_languages(%LanguageTag{cldr_locale_name: cldr_locale_name}) do
          known_languages(cldr_locale_name)
        end

        # Implement available_locales/known_locales
        for locale_name <- Locale.Loader.known_locale_names(config) do
          languages = locale_name |> Locale.Loader.get_locale(config) |> Map.get(:languages)

          def available_languages(unquote(locale_name)) do
            unquote(Enum.sort(Map.keys(languages)))
          end

          def known_languages(unquote(locale_name)) do
            unquote(Macro.escape(languages))
          end
        end

        def available_languages(locale), do: {:error, Locale.locale_error(locale)}

        def known_languages(locale), do: {:error, Locale.locale_error(locale)}

        @doc """
        Try to translate the given language iso code or language tag.

        ## Example

            iex> #{inspect(__MODULE__)}.Language.to_string("eo")
            {:ok, "Esperanto"}
        """
        @spec to_string(Locale.language() | LanguageTag.t()) ::
                {:ok, String.t()} | {:error, term()}
        @spec to_string(Locale.language() | LanguageTag.t(), Keyword.t()) ::
                {:ok, String.t()} | {:error, term()}
        def to_string(key, options \\ []) do
          key = standardize_locale(key)

          opts =
            %{}
            |> merge_style(options[:style])
            |> merge_locale(options[:locale])
            |> merge_fallback(options[:fallback])

          with {:ok, locale} <- backend().validate_locale(opts.locale) do
            result = to_string_by_locale(key, locale, opts)

            if result == :error && Map.fetch!(opts, :fallback) do
              to_string_by_locale(key, default_locale(), opts)
            else
              result
            end
          end
        end

        defp to_string_by_locale(%LanguageTag{language: language}, locale, opts) do
          to_string_by_locale(language, locale, opts)
        end

        defp to_string_by_locale(language, locale, %{style: style}) do
          with {:ok, lang} <- locale.cldr_locale_name |> known_languages() |> Map.fetch(language) do
            case Map.fetch(lang, style) do
              {:ok, _} = val -> val
              :error -> Map.fetch(lang, :standard)
            end
          end
        end

        # Merge style into options
        # Only allow @styles (default to standard)
        defp merge_style(opts, nil), do: Map.put(opts, :style, :standard)
        defp merge_style(opts, style) when style in @styles, do: Map.put(opts, :style, style)

        defp merge_style(opts, style) do
          msg =
            "Invalid :style  option #{inspect(style)} supplied. " <>
              "Valid styles are #{inspect(@styles)}."

          raise ArgumentError, msg
        end

        # Merge locale into options
        # Default to cldr's current locale
        defp merge_locale(opts, nil), do: Map.put(opts, :locale, get_locale())
        defp merge_locale(opts, locale), do: Map.put(opts, :locale, locale)

        # Merge fallback into options
        # Only allow booleans (default to false)
        defp merge_fallback(opts, nil), do: Map.put(opts, :fallback, false)

        defp merge_fallback(opts, fallback) when is_boolean(fallback),
          do: Map.put(opts, :fallback, fallback)

        defp merge_fallback(opts, fallback) do
          msg =
            "Invalid :fallback  option #{inspect(fallback)} supplied. " <>
              "Valid fallbacks are #{inspect([true, false])}."

          raise ArgumentError, msg
        end

        defp standardize_locale(locale) do
          case backend().validate_locale(locale) do
            {:ok, validated_locale} -> to_string(validated_locale)
            _ -> locale
          end
        end
      end
    end
  end
end
