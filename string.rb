require 'test/unit'

class StringTest < Test::Unit::TestCase

  def test_length
    s = "Hello, World!"
    assert_equal(13, s.length)
  end

  def test_expression_substitution
      assert_equal("Hello! Hello! Hello! ", "#{'Hello! ' * 3}")
  end

  def test_downcase
      assert_equal("asdf", "AsDF".downcase)
  end

  def test_squeeze
      assert_equal("too many spaces in this stuff", "too   many      spaces in   this    stuff".squeeze(' '));
      assert_equal("m thatsa spicy meatballa","mmmmm thatsssa spicy mmmeatballa".squeeze('m-t'));
  end

  def test_bracketed_regexp
      s = "the value of pi is ~3.145something"
      assert_equal('3.145', s[/[\d.]+/])
  end

  def test_match_thing
      url = "http://somewhere.com/someting/02/hh"
      assert_equal('http://somewhere.com/', url.match(/(^.*\/{2}[^\/]*\/)/)[1])
  end

  def test_mapping_thing_flattener
      fields = { :foo => ['thing1', 'thing2', [8,9,10], Time.now] }
      assert_equal(["thing1", "thing2", "8910", Time.now.to_s], fields[:foo].map(&:to_s))
  end
  
  def test_or_defaulting
      stuff = { :x => 345, :y => 89438 }
      default = 1
      bux = stuff[:z] || default
      assert_equal(1, bux)
      
      stuff[:z] = 999
      bux = stuff[:z] || default
      assert_equal(999, bux)
  end
