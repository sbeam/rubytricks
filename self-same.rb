require 'test/unit'

# this is silly, but proves that you can have Class and Instance methods with the same name,
# and switch amongst them with judicious use of 'self'. Believe it or not, this was something
# non-obvious once.

class Programmer
    def self.hi
        "hello world"
    end

    def hi
        self.class.hi
    end
end

class Brogrammer < Programmer
    def hi
        x = self.class.hi
        x.sub('world', 'dude')
    end
end



class BroTest < Test::Unit::TestCase

    def test_pro_says_hi
        pro = Programmer.new
        assert_equal("hello world", pro.hi)
    end

    def test_bro_says_dude
        bro = Brogrammer.new
        assert_equal("hello dude", bro.hi)
    end

end
