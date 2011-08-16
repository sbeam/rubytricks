require 'test/unit'

module Worker
    class Employee

        attr_accessor :name

        def initialize name
            @name = name
        end

        def name_and_rank
            "#{@name} - #{self.class.rank}"
        end

        def self.rank= r
           @rank = r
        end

        def self.rank
           @rank
        end

    end

    class Freelancer < Employee
        self.rank = 'Freelance'

        def self.rank= r
        end
    end
end

class IdentityTest < Test::Unit::TestCase

    def test_knows_who_he_is
        s = Worker::Employee.new 'Bobbo'
        assert_equal(s.name, 'Bobbo')
    end

    def test_assigns_a_rank
        Worker::Employee.rank = 'Peon'
        s = Worker::Employee.new 'Milton'
        assert_equal("Milton - Peon", s.name_and_rank)
    end

    def test_freelancer_has_no_rank_assignment
        Worker::Freelancer.rank = 'Peon'
        s = Worker::Freelancer.new "Bosco"
        assert_equal("Bosco - Freelance", s.name_and_rank)
    end

end


