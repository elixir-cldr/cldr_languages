defmodule Cldr.LanguageTest do
  use ExUnit.Case
  alias Cldr.Language.TestBackend
  # doctest MyApp.Backend.Language

  test "it can print the name of a language" do
    assert TestBackend.Language.to_string(:de) == {:ok, "German"}
  end

  test "it can print the short style of a language" do
    assert TestBackend.Language.to_string(:"en-GB", style: :short) !=
             TestBackend.Language.to_string(:"en-GB", style: :standard)
  end

  test "it does fall back to the standard style" do
    assert TestBackend.Language.to_string(:de, style: :short) ==
             TestBackend.Language.to_string(:de)
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
    assert {:ok, _} = TestBackend.Language.to_string(:ccp, locale: :de, fallback: true)
  end

  test "available_languages default to the current cldr locale" do
    TestBackend.put_locale("de")

    assert TestBackend.Language.available_languages() ==
             TestBackend.Language.available_languages(:de)
  end

  test "known_languages default to the current cldr locale" do
    TestBackend.put_locale("de")
    assert TestBackend.Language.known_languages() == TestBackend.Language.known_languages("de")

    TestBackend.put_locale(:de)
    assert TestBackend.Language.known_languages() == TestBackend.Language.known_languages(:de)
  end

  describe "default options" do
    test ":style does default to :standard" do
      assert TestBackend.Language.to_string("en-GB") ==
               TestBackend.Language.to_string("en-GB", style: :standard)

      assert TestBackend.Language.to_string(:"en-GB") ==
               TestBackend.Language.to_string(:"en-GB", style: :standard)
    end

    test ":locale does default to current locale" do
      TestBackend.put_locale("de")

      assert TestBackend.Language.to_string("en-GB") ==
               TestBackend.Language.to_string("en-GB", style: :standard, locale: "de")

      assert TestBackend.Language.to_string(:"en-GB") ==
               TestBackend.Language.to_string(:"en-GB", style: :standard, locale: :de)
    end

    test ":fallback does default to current locale" do
      assert TestBackend.Language.to_string("ccp", locale: "de") ==
               TestBackend.Language.to_string("ccp", locale: "de", fallback: false)

      assert TestBackend.Language.to_string(:ccp, locale: :de) ==
               TestBackend.Language.to_string(:ccp, locale: :de, fallback: false)
    end
  end

  describe "invalid options are detected" do
    test ":style" do
      assert_raise ArgumentError, fn ->
        TestBackend.Language.to_string("de", style: :invalid)
      end

      assert_raise ArgumentError, fn ->
        TestBackend.Language.to_string(:de, style: :invalid)
      end
    end

    test ":fallback" do
      assert_raise ArgumentError, fn ->
        TestBackend.Language.to_string("de", fallback: :invalid)
      end

      assert_raise ArgumentError, fn ->
        TestBackend.Language.to_string(:de, fallback: :invalid)
      end
    end
  end
end
