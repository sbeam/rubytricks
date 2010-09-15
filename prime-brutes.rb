require 'test/unit'

module PrimeFinder
    HARDLIMIT = 1000000

    class Brute

        def self.find pos 

            cnt = 0
            raise "arg must be a positive integer" unless pos > 0

            for i in (3..HARDLIMIT)
                f = i/2.to_i
                f.downto(1) { |f|
                    break if i.to_f/f.to_f == (i/f)
                }
                if (f==1) 
                    cnt += 1
                    return i if cnt == pos
                end
            end
        end
    end
end


class PrimesTest < Test::Unit::TestCase
    include PrimeFinder

    def test_string
        p = Brute::find 'squix';
        flunk "Should have had an exception here"
    rescue Exception => e
        assert_equal e.message, 'comparison of String with 0 failed'
    end

    def test_neg
        p = Brute::find -92
        flunk "Should have had an exception here"
    rescue Exception => e
        assert_equal e.message, "arg must be a positive integer"
    end

    def test_find
        p = Brute::find 11
        assert_equal(37, p)

        p = Brute::find 20
        assert_equal(73, p)
    end
end
