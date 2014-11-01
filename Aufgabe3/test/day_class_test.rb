# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'day_class'

class DayTest < Test::Unit::TestCase
  def test_day_num?
    assert_equal(true, day_num?(3))
    assert_equal(true, day_num?(7))
    assert_equal(false, day_num?(14))
    assert_equal(false, day_num?("l"))
  end
  
  def test_day_sym?
    assert_equal(true, day_sym?(:Mo))
    assert_equal(true, day_sym?(:Fr))
    assert_equal(false, day_sym?("Do"))
    assert_equal(false, day_sym?(2))
  end
  
  def test_day?
    assert_equal(true,day?(:Mo))
  end
end
