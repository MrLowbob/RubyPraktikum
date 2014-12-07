#Aufgabe: Day-Funktionen mit Klassen neu schreiben.

require 'test/unit'
require 'day_aufgabe4_2_test'

class DayTest < Test::Unit::TestCase
  
  def test_values
    assert_equal([:Mo, :Di, :Mi, :Do, :Fr, :Sa, :So],DS[:Fr].values())
  end
  
  def test_equals_2
    assert_equal(true, DN[1] == DS[:Mo])
  end
  
  def test_to_day_x
    assert_equal(DS[:Fr], DN[5].to_day_sym)
    assert_equal(DS[:Fr], DI[4].to_day_sym)
    assert_equal(DS[:Mo], DN[1].to_day_sym)
    assert_equal(DS[:Mo], DI[0].to_day_sym)
  end
  
  def test_add_succ_pred
    #Test +
    assert_equal(DS[:Fr], DS[:Mo] + 4)
    assert_equal(DN[5], DN[2] + 3)
    assert_equal(DI[5], DI[0] + 5)
    #Test succ
    assert_equal(DS[:Di], DS[:Mo].succ)
    assert_equal(DN[3], DN[2].succ)
    assert_equal(DI[1], DI[0].succ)
    #Test pred
    assert_equal(DS[:So], DS[:Mo].pred)
    assert_equal(DN[1], DN[2].pred)
    assert_equal(DI[6], DI[0].pred)
    #Test Errors
    assert_raise(RuntimeError) {DN[2] + "test"}
  end
end
