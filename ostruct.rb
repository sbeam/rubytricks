require 'test/unit'
require 'ostruct'

class OpenStructTest < Test::Unit::TestCase

  def test_hash
    d = getdata 
    assert_equal(2, d['b'])
    d.a
    flunk "Should have had an exception here"
    rescue Exception => e
       assert_match(/undefined method .a. for \{.*\}:Hash/, e.message)

  end

  def test_create
    d = getdata 
    os = OpenStruct.new(d)
    assert_equal 333, os.foo
    os.bar = 999
    assert_equal 999, os.bar
  end

  def test_copy
    y = OpenStruct.new(getdata)
    z = y.dup
    assert y == z

    z.baz = 'sharon'
    assert y != z
  end

  private
      def getdata
          { 'a' => 1, 'b' => 2, :foo => 333 }
      end

end

