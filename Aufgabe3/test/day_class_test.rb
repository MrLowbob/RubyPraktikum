# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'day_class'

class DayTest < Test::Unit::TestCase
  def test_day?
    assert_equal(true,day?(DaySym[:Mo]))
    assert_equal(true,day?(DaySym[:So]))
    assert_equal(true,day?(DayNum[1]))
    assert_equal(true,day?(DayNum[7]))
  end
end
