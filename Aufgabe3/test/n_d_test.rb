# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'n_d'

class N_d_test < Test::Unit::TestCase
  def test_classes
    assert_equal(true, point?(Point2d[1,5]))
    assert_equal(true, primshape?(Range2d[(2..7),(4..5)]))
    assert_equal(true, primshape?((-3..8)))
    assert_equal(true, unionshape?(Union2d[Range2d[(4..3),(1..4)], Range2d[(6..7), (4..5)]]))
    assert_equal(true, unionshape?(Union1d[(1..7),Union1d[(5..7),(3..2)]]))
    assert_equal(true, compshape?(Union1d[(1..7),Union1d[(5..7),(3..2)]]))
    assert_equal(true, shape?(Union1d[(1..7),Union1d[(5..7),(3..2)]]))
    assert_equal(true, shape?((-3..8)))
  end
end
