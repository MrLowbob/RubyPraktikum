# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'day_class'

class DayTest < Test::Unit::TestCase
  def test_day?
    assert_equal(true,day?(:Mo))
    assert_equal(true,day?(:So))
    assert_equal(true,day?(1))
    assert_equal(true,day?(7))
  end
  
  def test_to_day
    assert_equal(:Mo, to_day(:Mo, 1))
    assert_equal(:Mo, to_day(:Mo, :Mo))
    assert_equal(:Mi, to_day(:Mo, 3))
    assert_equal(:So, to_day(:Mo, :So))
    assert_equal(:So, to_day(:So, 7))
    
    assert_equal(1, to_day(1, :Mo))
    assert_equal(1, to_day(1, 1))
    assert_equal(6, to_day(5, :Sa))
    assert_equal(3, to_day(7, 3))
  end
  
  def test_day_shift
    assert_equal(:Mo, day_shift(:So, 1))
    assert_equal(:Di, day_shift(:So, 121))
    assert_equal(:Fr, day_shift(:So, -121))
  end
end
