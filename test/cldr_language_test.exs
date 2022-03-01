defmodule Cldr.LanguageTest do
  use ExUnit.Case
  alias Cldr.Language.TestBackend
  # doctest MyApp.Backend.Language

  @post_atom_locale Application.spec(:ex_cldr, :vsn)
                    |> List.to_string()
                    |> Version.match?("~> 2.26")

  defmacrop atom_or_string_locale(atom) do
    if @post_atom_locale do
      atom
    else
      Atom.to_string(atom)
    end
  end

  test "it can print the name of a language" do
    assert TestBackend.Language.to_string("de") == {:ok, "German"}
  end

  test "it can print the name of a language from a language tag" do
    # locale = atom_or_string_locale(:de)
    # Expects binary atm, not sure if that's correct or not
    # https://github.com/elixir-cldr/cldr/issues/169
    tag = Cldr.LanguageTag.parse!("de")
    assert TestBackend.Language.to_string(tag) == {:ok, "German"}
  end

  test "it can print the short style of a language" do
    assert TestBackend.Language.to_string("en-GB", style: :short) !=
             TestBackend.Language.to_string("en-GB", style: :standard)
  end

  test "it does fall back to the standard style" do
    assert TestBackend.Language.to_string("de", style: :short) ==
             TestBackend.Language.to_string("de")
  end

  test "that a valid but unknown locale does not cause infinite loops" do
    assert TestBackend.Language.available_languages(:nl) ==
             {:error, {Cldr.UnknownLocaleError, "The locale :nl is not known."}}

    assert TestBackend.Language.available_languages("nl") ==
             {:error, {Cldr.UnknownLocaleError, "The locale \"nl\" is not known."}}

    assert TestBackend.Language.available_languages({:bogus, :type}) ==
             {:error, {Cldr.UnknownLocaleError, "The locale {:bogus, :type} is not known."}}

    assert TestBackend.Language.known_languages(:nl) ==
             {:error, {Cldr.UnknownLocaleError, "The locale :nl is not known."}}

    assert TestBackend.Language.known_languages("nl") ==
             {:error, {Cldr.UnknownLocaleError, "The locale \"nl\" is not known."}}

    assert TestBackend.Language.known_languages({:bogus, :type}) ==
             {:error, {Cldr.UnknownLocaleError, "The locale {:bogus, :type} is not known."}}
  end

  test "it does fall back to the default locale if a language is not available in the selected one" do
    locale = atom_or_string_locale(:de)
    assert {:ok, _} = TestBackend.Language.to_string("ccp", locale: locale, fallback: true)
  end

  test "available_languages default to the current cldr locale" do
    TestBackend.put_locale("de")
    locale = atom_or_string_locale(:de)

    assert TestBackend.Language.available_languages() ==
             TestBackend.Language.available_languages(locale)
  end

  test "known_languages default to the current cldr locale" do
    TestBackend.put_locale(:de)
    locale = atom_or_string_locale(:de)
    assert TestBackend.Language.known_languages() == TestBackend.Language.known_languages(locale)
  end

  describe "default options" do
    test ":style does default to :standard" do
      assert TestBackend.Language.to_string("en-GB") ==
               TestBackend.Language.to_string("en-GB", style: :standard)
    end

    test ":locale does default to current locale" do
      TestBackend.put_locale("de")
      locale = atom_or_string_locale(:de)

      assert TestBackend.Language.to_string("en-GB") ==
               TestBackend.Language.to_string("en-GB", style: :standard, locale: locale)
    end

    test ":fallback does default to current locale" do
      locale = atom_or_string_locale(:de)

      assert TestBackend.Language.to_string("ccp", locale: locale) ==
               TestBackend.Language.to_string("ccp", locale: locale, fallback: false)
    end
  end

  describe "invalid options are detected" do
    test ":style" do
      assert_raise ArgumentError, fn ->
        TestBackend.Language.to_string("de", style: :invalid)
      end
    end

    test ":fallback" do
      assert_raise ArgumentError, fn ->
        TestBackend.Language.to_string("de", fallback: :invalid)
      end
    end
  end
end
