#Aufgabe: Day-Funktionen mit Klassen neu schreiben.

require 'test/unit'
require 'day_aufgabe4_1_test'

class DayTest < Test::Unit::TestCase

  DI = DayIndex
  
  def test_equal
    assert_equal(true, DN[1] == DN[1])
    assert_equal(false, DN[1] == DN[2])
    assert_equal(false, DN[1] == 5)
    assert_equal(true, DI[0] == DI[0])
    assert_equal(false, DI[0] == DI[2])
    assert_equal(false, DI[0] == 5)
    assert_equal(true, DS[:Mo] == DS[:Mo])
    assert_equal(false, DS[:Mo] == DS[:Di])
    assert_equal(false, DS[:Mo] == 5)
  end
  
  def test_to_s
    assert_equal("DayNum[3]", DN[3].to_s)
    assert_equal("DaySym[Di]", DS[:Di].to_s)
    assert_equal("DayIndex[2]", DI[2].to_s)
  end
  
  def test_day_shift
    assert_equal(DS[:Mo], DS[:So].day_shift(1))
    assert_equal(DS[:Di], DS[:So].day_shift(121))
    assert_equal(DS[:Fr], DS[:So].day_shift(-121))
    assert_equal(DN[2], DN[1].day_shift(1))
    assert_equal(DN[2], DN[1].day_shift(8))
    assert_equal(DN[7], DN[1].day_shift(-8))
    
    assert_raise(RuntimeError) {DS[:SO].day_shift(2.5)}
    assert_raise(RuntimeError) {DS[:Mo].day_shift("+2")}
    assert_raise(RuntimeError) {DS[:AB].day_shift(5)}
  end
end
