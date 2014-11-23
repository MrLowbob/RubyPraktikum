$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'day_class_aufg4_step3'

class Day_class_aufg4_step2 < Test::Unit::TestCase
    def test_values
      assert_equal([:Mo, :Di, :Mi, :Do, :Fr, :Sa, :So], DaySym[:Mo].values)
    end
    
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
    assert_equal(DayNum[3], DaySym[:Mi].to_day_num)
  end
  
  def to_day_index
    assert_equal(DayIndex[3], DayIndex[5].to_day_index)
    assert_equal(DayIndex[3], DaySym[:Fr].to_day_index)
    assert_equal(DayIndex[20], DayNum[5].to_day_index)
  end
  
#  def test_to_day
#    assert_equal(DayNum[1], DayNum[1].to_day(DayNum[4]))
#    assert_equal(DayNum[4], DayNum[4].to_day(DayNum[2]))
#    assert_equal(DaySym[:Di], DayNum[2].to_day(DaySym[:Do]))
#    assert_equal(DaySym[:Mi], DayNum[3].to_day(DaySym[:Mo]))
#    
#    assert_equal(DaySym[:Mi], DaySym[:Mi].to_day(DaySym[:Sa]))
#    assert_equal(DaySym[:So], DaySym[:So].to_day(DaySym[:Di]))
#    assert_equal(DayNum[1], DaySym[:Mo].to_day(DayNum[7]))
#    assert_equal(DayNum[4], DaySym[:Do].to_day(DayNum[1]))
#  end
#  
#  def test_shift
#    assert_equal(DaySym[:So], DaySym[:Mo]+(20))
#    assert_equal(DayNum[7], DayNum[2]+(40))
#    
#    assert_equal(DaySym[:Sa], DaySym[:Mo]-(23))
#    assert_equal(DayNum[1], DayNum[2]-(43))
#  end
#  
#  def test_to_s
#    assert_equal("DayNum[1]", DayNum[1].to_s)
#  end
#  
#  def test_samesame
#    assert_equal(true, DaySym[:Mo] == DaySym[:Mo])
#    assert_equal(false,DayNum[2] == DaySym[:Mo])
#  end
#  
#  def test_runtime
#    assert_raise(RuntimeError) {DayNum[30]}
#  end
end
