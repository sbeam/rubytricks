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

  def test_match_domain_in_url
      url = "http://somewhere.com/someting/02/hh"
      assert_equal('http://somewhere.com/', url.match(/(^.*\/{2}[^\/]*\/)/)[1])
  end

  def test_bracketed_regexp
      s = "the value of pi is ~3.145something"
      assert_equal('3.145', s[/[\d.]+/])
  end

  def test_bracketed_regexp_with_special_delims
      url = "http://zambo.com/you/can/do/anything"
      assert_equal('anything', url[%r|[^/]+\z|])
  end

  def test_match_url_basename_but_exclude_ext_and_params
      re = %r|([^/][^/\?.]+)[^/]*\z|
      urls = {
        'http://zambo.com/you/can/do-anything'                                  => 'do-anything',
        'http://zambo.com/you/can/do-quite_a>bit%2e v1.txt?times=9'             => 'do-quite_a>bit%2e v1',
        'http://zambo.com/i\'ll/do/anything/for/love/but/I/won\'t/do/that.txt'  => 'that',
        ## no :( # 'http://zambo.com/you/can/do.double.extensions?'                        => 'do.double',
      }
      urls.each do |url, m|
          assert_equal(m, url.match(re)[1])
      end
  end

  def test_global_replace
      s = "My SSN is 291-92-8423"
      assert_equal "My SSN is XXX-XX-XXXX", s.gsub(/\d/, 'X')
  end

  # this is a dumb test, but has different results on 1.8.6, 1.8.7, and 1.9.2
  def test_mapping_thing_flattener
      fields = { :foo => ['thing1', 'thing2', [8,9,10], Time.now] }
      assert_equal(["thing1", "thing2", "[8, 9, 10]", Time.now.to_s], fields[:foo].map(&:to_s))
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

  def test_gsub_match_pass_to_block
    str = "this {{is}} very {{awesome}}".gsub(/\{+([^{}]*)\}+/) { |s| $1.upcase }
    assert_equal("this IS very AWESOME", str)
  end
end
