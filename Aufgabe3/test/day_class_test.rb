# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'day_class'

class DayTest < Test::Unit::TestCase
  def test_day?
    assert_equal(true,day?(Daysym[:Mo]))
    assert_equal(true,day?(Daysym[:So]))
    assert_equal(false,day?(Daysym["Do"]))
    assert_equal(false,day?(Daysym[1]))
    assert_equal(true,day?(Daynum[1]))
    assert_equal(true,day?(Daynum[7]))
    assert_equal(false,day?(Daynum[:Mo]))
    assert_equal(false,day?(Daynum["1"]))
  end
end
