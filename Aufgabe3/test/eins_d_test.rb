# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'eins_d'

class Eins_d_test < Test::Unit::TestCase
  def test_range1d
    assert_equal(true, range1d?(3..7))
    assert_equal(false, range1d?("abc"))
  end
  
  def test_shapeid
    assert_equal(true, shape1d?(-3..5))
    assert_equal(true, shape1d?(Union1d[4..7, 8..9]))
    assert_equal(false, shape1d?("abc"))
    
    assert_raise(RuntimeError) {shape1d?(Union1d["ab", 1..3])}
  end
end
