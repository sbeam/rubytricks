require 'test/unit'

module PrimeFinder

    module Brute
        HARDLIMIT = 1000000

        def find_prime_at pos 

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
    include PrimeFinder::Brute

    def test_string
        p = find_prime_at 'squix';
        flunk "Should have had an exception here"
    rescue Exception => e
        assert_equal e.message, 'comparison of String with 0 failed'
    end

    def test_neg
        p = find_prime_at -92
        flunk "Should have had an exception here"
    rescue Exception => e
        assert_equal e.message, "arg must be a positive integer"
    end

    def test_find
        p = find_prime_at 11
        assert_equal(37, p)

        p = find_prime_at 20
        assert_equal(73, p)
    end
end
