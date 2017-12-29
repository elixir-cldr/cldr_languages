defmodule Cldr.LanguageTest do
  use ExUnit.Case
  doctest Cldr.Language

  test "it can print the name of a language" do
    assert Cldr.Language.to_string("de") == {:ok, "German"}
  end
  
  test "it can print the short style of a language" do
    assert Cldr.Language.to_string("en-GB", style: :short) != Cldr.Language.to_string("en-GB")
    assert Cldr.Language.to_string("en-GB", style: :short) == {:ok, "UK English"}
  end
  
  test "it does fall back to the standard style" do
    assert Cldr.Language.to_string("de", style: :short) == Cldr.Language.to_string("de")
  end
  
  test "it does fall back to the default locale if a language is not available in the selected one" do
    assert {:ok, _} = Cldr.Language.to_string("ccp", style: :short, locale: "de", fallback: true)
  end

  describe "invalid options are detected" do
    test "styles" do
      assert_raise ArgumentError, fn -> 
        Cldr.Language.to_string("de", style: :invalid)
      end
    end

    test "fallback" do
      assert_raise ArgumentError, fn -> 
        Cldr.Language.to_string("de", fallback: :invalid)
      end
    end
  end
end
