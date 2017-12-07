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
end
