#Aufgabe: Day-Funktionen mit Klassen neu schreiben.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'day_class'

class DayTest < Test::Unit::TestCase
  
  DS = DaySym
  DN = DayNum
  
  def test_invariant
    assert_raise(RuntimeError) {DS[:AB]}
    assert_raise(RuntimeError) {DS[3]}
    assert_raise(RuntimeError) {DN[:Mo]}
    assert_raise(RuntimeError) {DS[8]}
  end
  
  def test_day?
    assert_equal(true,day?(DS[:Mo]))
    assert_equal(true,day?(DS[:So]))
    assert_equal(true,day?(DN[1]))
    assert_equal(true,day?(DN[7]))
    
    assert_raise(RuntimeError) {day?(DS[:AB])}
    assert_raise(RuntimeError) {day?(DN[8])}
  end
  
  def test_to_day
    assert_equal(DS[:Mo], to_day(DS[:Mo], DN[1]))
    assert_equal(DS[:Mo], to_day(DS[:Mo], DS[:Mo]))
    assert_equal(DS[:Mi], to_day(DS[:Mo], DN[3]))
    assert_equal(DS[:So], to_day(DS[:Mo], DS[:So]))
    assert_equal(DS[:So], to_day(DS[:So], DN[7]))
    
    assert_equal(DN[1], to_day(DN[1], DS[:Mo]))
    assert_equal(DN[1], to_day(DN[1], DN[1]))
    assert_equal(DN[6], to_day(DN[5], DS[:Sa]))
    assert_equal(DN[3], to_day(DN[7], DN[3]))
    
    assert_raise(RuntimeError) {to_day(DS[:Mo], DN[:Mo])}
    assert_raise(RuntimeError) {to_day(DS[3], DN[5])}
  end
  
  def test_day_shift
    assert_equal(DS[:Mo], day_shift(DS[:So], 1))
    assert_equal(DS[:Di], day_shift(DS[:So], 121))
    assert_equal(DS[:Fr], day_shift(DS[:So], -121))
    assert_equal(DN[2], day_shift(DN[1],1))
    assert_equal(DN[2], day_shift(DN[1],8))
    assert_equal(DN[7], day_shift(DN[1],-8))
    
    assert_raise(RuntimeError) {day_shift(DS[:SO], 2.5)}
    assert_raise(RuntimeError) {day_shift(DS[:Mo], "+2")}
    assert_raise(RuntimeError) {day_shift(DS[:AB], 5)}
  end
end
