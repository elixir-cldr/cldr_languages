defmodule Cldr.LanguageTest do
  use ExUnit.Case
  doctest Cldr.Language

  test "the default locales' languages are considered the baseline for which languages are available (all_languages/0)" do
    assert Cldr.Language.all_languages == Cldr.Language.available_languages(Cldr.default_locale)
  end

  test "it can print the name of a language" do
    assert Cldr.Language.to_string("de") == {:ok, "German"}
  end
  
  test "it can print the short style of a language" do
    assert Cldr.Language.to_string("en-GB", style: :short) != Cldr.Language.to_string("en-GB", style: :standard)
  end
  
  test "it does fall back to the standard style" do
    assert Cldr.Language.to_string("de", style: :short) == Cldr.Language.to_string("de")
  end
  
  test "it does fall back to the default locale if a language is not available in the selected one" do
    assert {:ok, _} = Cldr.Language.to_string("ccp", locale: "de", fallback: true)
  end

  test "available_languages default to the current cldr locale" do
    Cldr.set_current_locale("de")
    assert Cldr.Language.available_languages() == Cldr.Language.available_languages("de")
  end

  test "known_languages default to the current cldr locale" do
    Cldr.set_current_locale("de")
    assert Cldr.Language.known_languages() == Cldr.Language.known_languages("de")
  end

  describe "default options" do
    test ":style does default to :standard" do
      assert Cldr.Language.to_string("en-GB") == Cldr.Language.to_string("en-GB", style: :standard)
    end

    test ":locale does default to current locale" do
      Cldr.set_current_locale("de")
      assert Cldr.Language.to_string("en-GB") == Cldr.Language.to_string("en-GB", style: :standard, locale: "de")
    end

    test ":fallback does default to current locale" do
      assert Cldr.Language.to_string("ccp", locale: "de") == Cldr.Language.to_string("ccp", locale: "de", fallback: false)
    end
  end

  describe "invalid options are detected" do
    test ":style" do
      assert_raise ArgumentError, fn -> 
        Cldr.Language.to_string("de", style: :invalid)
      end
    end

    test ":fallback" do
      assert_raise ArgumentError, fn -> 
        Cldr.Language.to_string("de", fallback: :invalid)
      end
    end
  end
end
