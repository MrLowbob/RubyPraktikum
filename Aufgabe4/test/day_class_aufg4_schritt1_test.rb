$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'day_class_aufg4_schritt1'

class Day_class_aufg4_test < Test::Unit::TestCase
  def test_to_day_sym
    assert_equal(DaySym[:Mo], DayNum[1].to_day_sym)
    assert_equal(DaySym[:Di], DayNum[2].to_day_sym)
    assert_equal(DaySym[:Mi], DayNum[3].to_day_sym)
    assert_equal(DaySym[:So], DayNum[7].to_day_sym)
    assert_equal(DaySym[:Fr], DayNum[5].to_day_sym)
    
    assert_equal(DaySym[:Mo], DaySym[:Mo].to_day_sym)
    assert_equal(DaySym[:So], DaySym[:So].to_day_sym)
  end
  
  def test_to_day_num
    assert_equal(DayNum[1], DaySym[:Mo].to_day_num)
    assert_equal(DayNum[5], DaySym[:Fr].to_day_num)
    assert_equal(DayNum[3], DaySym[:Mi].to_day_num)
    assert_equal(DayNum[7], DaySym[:So].to_day_num)
    
    assert_equal(DayNum[1], DayNum[1].to_day_num)
    assert_equal(DayNum[7], DayNum[7].to_day_num)
  end
  
  def test_to_day
    assert_equal(DayNum[1], DayNum[1].to_day(DayNum[4]))
    assert_equal(DayNum[4], DayNum[4].to_day(DayNum[2]))
    assert_equal(DaySym[:Di], DayNum[2].to_day(DaySym[:Do]))
    assert_equal(DaySym[:Mi], DayNum[3].to_day(DaySym[:Mo]))
    
    assert_equal(DaySym[:Mi], DaySym[:Mi].to_day(DaySym[:Sa]))
    assert_equal(DaySym[:So], DaySym[:So].to_day(DaySym[:Di]))
    assert_equal(DayNum[1], DaySym[:Mo].to_day(DayNum[7]))
    assert_equal(DayNum[4], DaySym[:Do].to_day(DayNum[1]))
  end
  
  def test_shift
    assert_equal(DaySym[:So], DaySym[:Mo]+(20))
    assert_equal(DayNum[7], DayNum[2]+(40))
    
    assert_equal(DaySym[:Sa], DaySym[:Mo]-(23))
    assert_equal(DayNum[1], DayNum[2]-(43))
  end
end

#to_day_index testet sich dur to_day_num und to_day_sym