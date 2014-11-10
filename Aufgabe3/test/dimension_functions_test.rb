# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'dimension_functions'

class Dimension_functions_test < Test::Unit::TestCase
  def test_shape_include
    assert_equal(true,  shape_include?((1..3), 1))
    assert_equal(true,  shape_include?((-10..-2), -5))
    assert_equal(false, shape_include?((1..4), 5))
    assert_equal(true,  shape_include?(Range2d[(1..3), (4..7)], Point2d[2,5]))
    assert_equal(false, shape_include?(Range2d[(5..4),(7..8)], Point2d[5,7]))
    assert_equal(true,  shape_include?(Union2d[Range2d[(1..3),(3..4)],Union2d[Range2d[(4..5),(3..4)], Range2d[(13..14), (4..5)]]], Point2d[13,5]))
    assert_equal(false, shape_include?(Union2d[Range2d[(1..3),(3..4)],Union2d[Range2d[(4..5),(3..4)], Range2d[(13..14), (4..5)]]], Point2d[5,20]))
  end
  
  def test_translate
    assert_equal((2..4), translate((1..3), 1))
    assert_equal(Range2d[(3..5), (9..12)], translate(Range2d[(1..3), (4..7)], Point2d[2,5]))
    assert_equal(Union2d[Range2d[(2..4),(5..6)],Union2d[Range2d[(5..6),(5..6)], Range2d[(14..15), (6..7)]]], 
       translate(Union2d[Range2d[(1..3),(3..4)],Union2d[Range2d[(4..5),(3..4)], Range2d[(13..14), (4..5)]]], Point2d[1,2]))
  end
  
  def test_bounds
    assert_equal((1..3), bounding_range((1..3),(2..3)))
    assert_equal((1..3), bounds((1..3)))
    assert_equal(Range2d[(1..5),(3..4)], bounds(Union2d[Range2d[(1..3),(3..4)], Range2d[(4..5),(3..4)]]))
    assert_equal(Range2d[(1..14),(3..5)], bounds(Union2d[Range2d[(1..3),(3..4)],Union2d[Range2d[(4..5),(3..4)], Range2d[(13..14), (4..5)]]]))
  end
  
  def test_equal_by_dim
    assert_equal(true, equal_by_dim?(Range2d[(1..5),(3..4)], Range2d[(1..14),(3..5)]))
    assert_equal(true, equal_by_dim?(Range2d[(1..5),(3..4)], Point2d[1,2] ))
    assert_equal(true, equal_by_dim?(Union2d[Range2d[(1..3),(3..4)], Range2d[(4..5),(3..4)]],Union2d[Range2d[(4..5),(3..4)], Range2d[(13..14), (4..5)]]))
    assert_equal(true, equal_by_dim?(1,(1..3)))
    assert_equal(true, equal_by_dim?(1, Union1d[(1..3),(1..4)]))
    assert_equal(false,equal_by_dim?(1, Range2d[(1..5),(3..4)]))   
  end
  
  def test_equal_by_tree
    assert_equal(false,equal_by_tree?(1, (3..4)))
    assert_equal(false ,equal_by_tree?(Union2d[Range2d[(1..3),(3..4)], Range2d[(4..5),(3..4)]],Union2d[Union2d[Range2d[(4..5),(3..4)], Range2d[(13..14), (4..5)]], Range2d[(13..14), (4..5)]]))
    assert_equal(true ,equal_by_tree?(Union2d[Range2d[(1..3),(3..4)], Range2d[(4..5),(3..4)]],Union2d[Range2d[(4..5),(3..4)], Range2d[(13..14), (4..5)]]))
    assert_equal(true ,equal_by_tree?(Union1d[Union1d[(1..3),(-2..7)], (4..5)], Union1d[Union1d[(1..4),(-2..7)], (4..5)] )) 
    assert_equal(true ,equal_by_tree?(Union2d[Range2d[(1..3),(3..4)], Range2d[(4..5),(3..4)]],Union2d[Range2d[(4..5),(3..4)], Range2d[(13..14), (4..5)]]))
  end
end
