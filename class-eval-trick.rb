require 'test/unit'


# this is interesting at least to me. If x is an instance of Class Foo, you can
# use Foo.class_eval and friends to modify instance methods, and this affects
# existing instance x and all other extant inherit-ees at runtime. Good to
# know.

class Person
    def greet
        "hello"
    end
end

class PolitePerson < Person
    def greet
        x = super
        x << ", sir"
    end
end



class FrozTest < Test::Unit::TestCase

    # PolitePerson calls super and gets the result from its parent. Nothing surprising.
    def test_super_does_what_it_does
        b = PolitePerson.new
        assert_equal "hello, sir", b.greet
    end
end

class FrozTestTakeTwo < Test::Unit::TestCase

    def test_change_everything_with_eval
        # new instances of ordinary easterners
        a = Person.new
        b = PolitePerson.new

        # open up the Class and give it a Western twang!
        Person.class_eval do
            def greet
                "howdy"
            end
        end

        # a became a cowboy!
        assert_equal "howdy", f.greet

        # what's this? b's got spurs on too!
        assert_equal "howdy, sir", b.greet
    end

end
