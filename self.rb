require 'test/unit'

module Worker
    class Employee

        attr_accessor :name

        def self.attr_minimum(args)
            args.each do |k, v|
                attr_accessor k.to_sym

                class_variable_set("@@min_#{k}", v)

                 define_method "#{k}=".to_sym do |value|
                     min = self.class.send(:class_variable_get, "@@min_#{k}")

                     raise "that #{k} is too low!" if (value < min)

                     instance_eval "@#{k} = value"
                end
            end

            puts args.keys.inspect
            class_variables.each do |var|
                if m = var.to_s.match(/^@@min_(.+)/)
                    meth = "#{m[1]}="
                    undef_method meth unless args.keys.include? m[1].to_sym
                end

            end
        end

        attr_minimum :salary => 40_000, :age => 18

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
        attr_minimum :rate => 125, :age => 21

        self.rank = 'Freelance'

        def self.rank= r
        end
    end
end

Worker::Employee.class_eval do
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

    def test_no_complains_about_a_nice_high_rate
        s = Worker::Freelancer.new "Bosco"
        s.rate = 130
        assert_equal 130, s.rate
    end

    def test_complaints_about_a_low_rate
        s = Worker::Freelancer.new "Bosco"
        s.rate = 24
        #s.salary = 99_200
        flunk "Should have had an exception because that rate is too low"
    rescue Exception => e
        assert_equal 'that rate is too low!', e.message
    end

    def test_freelancer_cant_have_a_salary
        s = Worker::Freelancer.new "Bosco"
        s.salary = 99_200
        flunk "Should have had an exception"
    rescue Exception => e
        assert_match /^undefined method `salary=/, e.message
    end

end


