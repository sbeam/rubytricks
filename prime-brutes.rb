require 'test/unit'

module PrimeFinder

    module Brute
        HARDLIMIT = 1000000

        def find_prime_at pos 

            cnt = 0
            raise "arg must be a positive integer" unless pos > 0

            for i in (3..HARDLIMIT)
                if is_prime i
                    cnt += 1
                    return i if cnt == pos
                end
            end
        end

        def is_prime i

            raise "arg must be a positive integer greater than 1" unless i > 1

            f = i/2.to_i
            f.downto(2) { |f|
                return if i.to_f/f.to_f == (i/f)
            }
            true
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

    def test_is_prime
        assert_nil is_prime(8)
        assert_nil is_prime(81)
        assert_equal true, is_prime(29)
        assert_equal true, is_prime(48611)
    end

    def test_find
        p = find_prime_at 11
        assert_equal(37, p)

        p = find_prime_at 20
        assert_equal(73, p)
    end
end
