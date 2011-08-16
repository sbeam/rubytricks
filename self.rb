require 'test/unit'


# a test to play around with a little meta-programming in Ruby, and create an include-able Module, that
# implements a basic validation against instance variables
#
# note that even though Employee.class_eval is used to set the validate_minimum, it does the right thing and
# does not cause Freelancer to have a 'salary=' method, even though Freelancer < Employee. That is the trick and
# why the metaclass was needed.
#
# credits:
# http://www.ruby-doc.org/core/classes/Module.html
# http://mislav.uniqpath.com/poignant-guide/dwemthy/ < --- awesome.
# http://dannytatom.github.com/metaid/
# http://yehudakatz.com/2009/11/15/metaprogramming-in-ruby-its-all-about-the-self/
# http://www.raulparolari.com/Ruby2/define_method
#

module MyValidator

    def self.included(base)
        base.extend(ClassMethods)
    end

    module ClassMethods
        def validate_minimum(arg)
            metaclass.send(:class_variable_set, "@@minimums", arg)

            arg.each do |k, v|
                attr_accessor k

                define_method "#{k}=" do |value|
                    min = self.class.metaclass.send(:class_variable_get, "@@minimums")
                    raise "that #{k} is too low!" if (min[k] and value < min[k])

                    if min[k]
                        instance_eval "@#{k} = value"
                    else
                        raise ArgumentError, "undefined method `#{k}' for #{self.to_s}" # imitate the default :/
                    end
                end
            end
        end

        def metaclass; class << self; self; end; end
    end
end

class Employee
    include MyValidator

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

    validate_minimum :rate => 125, :age => 21

    self.rank = 'Freelance'

    def self.rank= r
    end
end

Employee.class_eval do
    validate_minimum :salary => 40_000, :age => 18
end


class IdentityTest < Test::Unit::TestCase

    def test_knows_who_he_is
        s = Employee.new 'Bobbo'
        assert_equal(s.name, 'Bobbo')
    end

    def test_assigns_a_rank
        Employee.rank = 'Peon'
        s = Employee.new 'Milton'
        assert_equal("Milton - Peon", s.name_and_rank)
    end

    def test_freelancer_has_no_rank_assignment
        Freelancer.rank = 'Peon'
        s = Freelancer.new "Bosco"
        assert_equal("Bosco - Freelance", s.name_and_rank)
    end

    def test_no_complains_about_a_nice_high_rate
        s = Freelancer.new "Bosco"
        s.rate = 130
        assert_equal 130, s.rate
    end

    def test_complaints_about_a_low_rate
        s = Freelancer.new "Bosco"
        s.rate = 24
        #s.salary = 99_200
        flunk "Should have had an exception because that rate is too low"
    rescue Exception => e
        assert_equal 'that rate is too low!', e.message
    end

    def test_freelancer_cant_have_a_salary
        s = Freelancer.new "Bosco"
        s.salary = 99_200
        flunk "Should have had an exception"
    rescue Exception => e
        assert_match /^undefined method `salary/, e.message
    end

    def test_emp_can_have_salary
        s = Employee.new "Cindy"
        s.salary = 102_000
        assert_equal 102_000, s.salary
    end

    def test_emp_cant_have_a_low_salary
        s = Employee.new "Cindy"
        s.salary = 2_000
        flunk "Should have had an exception because that salary is too low"
    rescue Exception => e
        assert_equal 'that salary is too low!', e.message
    end

    def test_emp_cant_have_a_rate
        s = Employee.new "Cindy"
        s.rate = 200
        flunk "Should have had an exception"
    rescue Exception => e
        assert_match /^undefined method `rate/, e.message
    end

end


