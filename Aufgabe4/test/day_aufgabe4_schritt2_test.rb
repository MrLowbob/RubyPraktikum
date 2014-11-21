#Aufgabe: Day-Funktionen mit Klassen neu schreiben.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'day_aufgabe4_schritt2'

class DayTest < Test::Unit::TestCase
  
  DS = DaySym
  DN = DayNum
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
  
  def test_invariant
    assert_equal(DayNum.new(3), DayNum[3])
    assert_raise(RuntimeError) {DS[:AB]}
    assert_raise(RuntimeError) {DS[3]}
    assert_raise(RuntimeError) {DN[:Mo]}
    assert_raise(RuntimeError) {DS[8]}
  end
  
  def test_day?
    assert_equal(true,DS[:Mo].day?)
    assert_equal(true,DS[:So].day?)
    assert_equal(true,DN[1].day?)
    assert_equal(true,DN[7].day?)
    assert_equal(false,5.day?)
    
    assert_raise(RuntimeError) {day?(DS[:AB])}
    assert_raise(RuntimeError) {day?(DN[8])}
  end
  
  def test_to_day
    assert_equal(DS[:Mo], DN[1].to_day(DS[:Mo]))
    assert_equal(DS[:Mo], DS[:Mo].to_day(DS[:Mo]))
    assert_equal(DS[:Mi], DN[3].to_day(DS[:Mo]))
    assert_equal(DS[:So], DS[:So].to_day(DS[:Mo]))
    assert_equal(DS[:So], DN[7].to_day(DS[:So]))
    
    assert_equal(DN[1], DS[:Mo].to_day(DN[1]))
    assert_equal(DN[1], DN[1].to_day(DN[1], ))
    assert_equal(DN[6], DS[:Sa].to_day(DN[5], ))
    assert_equal(DN[3], DN[3].to_day(DN[7], ))
    
    assert_raise(RuntimeError) {DN[:Mo].to_day(DS[:Mo])}
    assert_raise(RuntimeError) {DN[5].to_day(DS[3])}
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
