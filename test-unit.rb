require 'test/unit'

module Translator
    module PigLatin
        def translate str
            return str + 'ay' if str.match /^[aeiouy]+/
            str.sub(/(^[^aeiouy]+)(.*)$/) { |s| $2 + $1 + 'ay' }
        end

        def boom str
            raise "go boom"
        end
    end
end

class PigLatinTest < Test::Unit::TestCase
    include Translator::PigLatin

    def test_simple_word
        s = translate("nix")
        assert_equal("ixnay", s)
    end

    def test_word_beginning_with_vowel
        s = translate("apple")
        assert_equal("appleay", s)
    end

    def test_two_consonant_word
        s = translate("drowsy")
        assert_equal("owsydray", s)
    end

    def test_boom
        s = boom 'foo'
        flunk "Should have had an exception here"
    rescue Exception => e
        assert_equal e.message, 'go boom'
    end
end


