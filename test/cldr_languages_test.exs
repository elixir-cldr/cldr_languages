defmodule Cldr.LanguageTest do
  use ExUnit.Case

  doctest Cldr.Language
  doctest TestBackend.Cldr.Language

  test "the default locales' languages are considered the baseline for which languages are available (all_languages/0)" do
    assert Cldr.Language.all_languages(TestBackend.Cldr) == Cldr.Language.available_languages(TestBackend.Cldr.default_locale(), TestBackend.Cldr)
  end

  test "it can print the name of a language" do
    assert Cldr.Language.to_string("de", TestBackend.Cldr) == {:ok, "German"}
  end

  test "it can print the short style of a language" do
    assert Cldr.Language.to_string("en-GB", TestBackend.Cldr, style: :short) != Cldr.Language.to_string("en-GB", TestBackend.Cldr, style: :standard)
  end

  test "it does fall back to the standard style" do
    assert Cldr.Language.to_string("de", TestBackend.Cldr, style: :short) == Cldr.Language.to_string("de", TestBackend.Cldr)
  end

  test "it does fall back to the default locale if a language is not available in the selected one" do
    assert {:ok, _} = Cldr.Language.to_string("ccp", TestBackend.Cldr, locale: "de", fallback: true)
  end

  test "available_languages default to the current cldr locale" do
    TestBackend.Cldr.put_locale("de")
    assert Cldr.Language.available_languages(TestBackend.Cldr.get_locale(), TestBackend.Cldr) == Cldr.Language.available_languages("de", TestBackend.Cldr)
  end

  test "known_languages default to the current cldr locale" do
    TestBackend.Cldr.put_locale("de")
    assert Cldr.Language.known_languages(TestBackend.Cldr.get_locale(), TestBackend.Cldr) == Cldr.Language.known_languages("de", TestBackend.Cldr)
  end

  describe "default options" do
    test ":style does default to :standard" do
      assert Cldr.Language.to_string("en-GB", TestBackend.Cldr) == Cldr.Language.to_string("en-GB", TestBackend.Cldr, style: :standard)
    end

    test ":locale does default to current locale" do
      TestBackend.Cldr.put_locale("de")
      assert Cldr.Language.to_string("en-GB", TestBackend.Cldr) == Cldr.Language.to_string("en-GB", TestBackend.Cldr, style: :standard, locale: "de")
    end

    test ":fallback does default to current locale" do
      assert Cldr.Language.to_string("ccp", TestBackend.Cldr, locale: "de") == Cldr.Language.to_string("ccp", TestBackend.Cldr, locale: "de", fallback: false)
    end
  end

  describe "invalid options are detected" do
    test ":style" do
      assert_raise ArgumentError, fn ->
        Cldr.Language.to_string("de", TestBackend.Cldr, style: :invalid)
      end
    end

    test ":fallback" do
      assert_raise ArgumentError, fn ->
        Cldr.Language.to_string("de", TestBackend.Cldr, fallback: :invalid)
      end
    end
  end
end
