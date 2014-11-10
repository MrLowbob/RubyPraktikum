# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'zwei_d'

class Zwei_d_test < Test::Unit::TestCase
  def test_point2d
    assert_equal(true, (Point2d[1,4]).point2d?)
    assert_equal(true, (Range2d[(1..3),(3..9)]).range2d?)
    assert_equal(true, (Union2d[Range2d[(1..3),(8..9)], Range2d[(5..6),(-3..5)]]).union2d?)
    assert_equal(true, shape2d?(Union2d[Range2d[(1..3),(8..9)], Range2d[(5..6),(-3..5)]]))
    assert_equal(true, shape2d?(Union2d[Range2d[(1..3),(8..9)], Union2d[Range2d[(1..3),(8..9)], Range2d[(5..6),(-3..5)]]]))
  end
end

#Union2d[Range2d[Point2d[1,9], Point2d[9,0]], Range2d[Point2d[7,5], Point2d[3,4]]]