#Aufgabe: Day-Funktionen mit Klassen neu schreiben.

require 'test/unit'

class DayTest < Test::Unit::TestCase
  
  DS = DaySym
  DN = DayNum
  
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
end
