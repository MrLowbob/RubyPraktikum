# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'graphics'

class GraphicsTest < Test::Unit::TestCase
  
  ##
  #1D Tests
  
  def test_point1d?
    assert_equal(true, point1d?(3))
    assert_equal(true, point1d?(0))
    assert_equal(true, point1d?(-2))
    
    assert_equal(false, point1d?(2.5))
    assert_equal(false, point1d?("2.5"))
  end
  
  def test_range1d?
    assert_equal(true, range1d?(3..5))
    assert_equal(true, range1d?(-2..2))
    assert_equal(true, range1d?(3..3))
    assert_equal(true, range1d?(5..1))
    assert_equal(false, range1d?("3..5"))
    assert_equal(false, range1d?(3))
    assert_equal(false, range1d?('a'..'b'))
  end
  
  U1d = Union1d
  
  def test_invariant_union1d
    assert_raise(RuntimeError) {U1d[(3..5),('x'..'y')]}
    assert_raise(RuntimeError) {U1d[5,(3..5)]}
  end
  
  def test_shape1d?
    assert_equal(true, shape1d?((3..4)))
    assert_equal(true, shape1d?((U1d[(3..5),(7..9)])))
    assert_equal(false, shape1d?((3)))
  end
  
  ###
  # 2d-Tests
  P2d = Point2d
  R2d = Range2d
  U2d = Union2d
  def test_invariants_2d_objects
    #point2d
    assert_raise(RuntimeError) {P2d[5,"b"]}
    assert_raise(RuntimeError) {P2d[2.5,6]}
    #range2d
    assert_raise(RuntimeError) {R2d[5,(2..5)]}
    assert_raise(RuntimeError) {R2d[('a'..'b'), (2..5)]}
    #union2d
    assert_raise(RuntimeError) {U2d[R2d[(1..2),(3..4)],5]}
    assert_raise(RuntimeError) {U2d[R2d[('a'..'b'),(3..4)],R2d[(1..2),(3..4)]]}
  end
  
  def test_shape2d?
    assert_equal(true, shape2d?(R2d[(2..3), (4..5)]))
    assert_equal(true, shape2d?(U2d[R2d[(2..3), (4..5)],R2d[(2..3), (4..5)]]))
    assert_equal(false, shape2d?(P2d[5,7]))
    assert_equal(false, shape2d?(5))
  end
  
  #Dimensionsunabhängig
  def test_predicates
    #Point
    assert_equal(true, point?(5))
    assert_equal(true, point?(P2d[5,7]))
    assert_equal(false, point?('a'))
    #PrimShape
    assert_equal(true, prim_shape?(2..5))
    assert_equal(true, prim_shape?(R2d[(2..5),(4..6)]))
    assert_equal(false, prim_shape?(3))
    #UnionShape
    assert_equal(true, union_shape?(U1d[(2..4),(6..7)]))
    assert_equal(true, union_shape?(U2d[R2d[2..5, 4..6], R2d[5..7, 2..3]]))
    assert_equal(false, union_shape?(6))
    #CompShape
    assert_equal(true, comp_shape?((U1d[2..4,6..7])))
    assert_equal(false, union_shape?(6))
    #Shape
    assert_equal(true, shape?((U1d[2..4,6..7])))
    assert_equal(true, shape?((R2d[2..4,6..7])))
    assert_equal(false, shape?(6))
    #GraphObj
    assert_equal(true, graph_obj?(5))
    assert_equal(true, graph_obj?(U1d[2..4,6..7]))
  end
  
  #Funktionstests
  #Shape_include?
  def test_shape_include?
    assert_equal(true, shape_include?((3..5),4))
    assert_equal(true, shape_include?(R2d[(3..5),(3..5)],P2d[4,4]))
    assert_equal(true, shape_include?(U2d[R2d[(3..5),(3..5)],R2d[(1..2),(8..9)]],P2d[4,4]))
    assert_equal(false, shape_include?(R2d[(3..5),(3..5)],P2d[6,6]))
    assert_equal(false, shape_include?((3..5),8))
    
    assert_raise(RuntimeError) {shape_include?((3..5), P2d[3,5])}
    assert_raise(RuntimeError) {shape_include?(R2d[(3..5),(3..5)], 5)}
    assert_raise(RuntimeError) {shape_include?("a", "a")}
  end
  
  #translate
  def test_translate
    assert_equal(4..6, translate(3..5,1))
    assert_equal(U1d[2..5, 8..9], translate(U1d[4..7, 10..11], -2))
    assert_equal(R2d[2..5, 8..9], translate(R2d[4..7, 10..11], P2d[-2,-2]))
    assert_equal(U2d[R2d[2..5, 8..9],R2d[3..4, 3..4]], translate(U2d[R2d[1..4, 9..10],R2d[2..3, 4..5]], P2d[1,-1]))
    
    assert_raise(RuntimeError) {translate(2..4,"a")}
    assert_raise(RuntimeError) {translate(2..4,P2d[1,1])}
    assert_raise(RuntimeError) {translate(R2d[2..4,2..4],1)}
  end
  
  #bounds
  def test_bounds
    #1d
    assert_equal(2..4, bounds(2..4))
    assert_equal(2..6, bounds(U1d[2..3, 5..6]))
    assert_equal(2..8, bounds(U1d[2..3,U1d[7..8, 5..6]]))
    assert_equal(2..8, bounds(U1d[U1d[7..8, 5..6],2..3]))
    #2d
    assert_equal(R2d[2..4, 2..4], bounds(U2d[R2d[2..4,2..3],R2d[2..4,3..4]]))
    assert_equal(R2d[2..5, 2..6], bounds(U2d[U2d[R2d[2..4,2..3],R2d[2..4,3..4]],R2d[2..5,2..6]]))
  end
  #bounding_range
  
  ###
  #Equalities
  #equal_by_dim?
  def test_equal_by_dim?
    assert_equal(true, equal_by_dim?(3,5))
    assert_equal(true, equal_by_dim?(2..5,4))
    assert_equal(true, equal_by_dim?((3..4),U1d[2..3, 5..7]))
    assert_equal(true, equal_by_dim?(P2d[3,5],P2d[5,7]))
    assert_equal(true, equal_by_dim?(R2d[3..4,5..6], U2d[R2d[5..6,5..6],R2d[1..2,2..3]]))
    assert_equal(false, equal_by_dim?(P2d[3,5],5))
    
    assert_raise(RuntimeError) {equal_by_dim?("34",5)}
  end
  #equal_by_tree?
  def test_equal_tree?
    assert_equal(true, equal_by_tree?(3,3))
    assert_equal(true, equal_by_tree?((3..5),(3..5)))
    assert_equal(true, equal_by_tree?(U2d[R2d[3..4,3..4],R2d[5..6,5..6]],U2d[R2d[3..4,3..4],R2d[5..6,5..6]]))
    assert_equal(false, equal_by_tree?(3..4,5..6))
    assert_equal(false, equal_by_tree?(3,5))
    assert_equal(false, equal_by_tree?(U1d[3..5,5..6],(3..5)))
    assert_equal(false, equal_by_tree?(U1d[3..5,5..6],U1d[3..5,4..7]))
    assert_equal(false, equal_by_tree?(R2d[3..5,4..5],U1d[3..4,4..5]))
  end
  #equal_by_trans?
  def test_equal_trans?
    assert_equal(true, equal_by_trans?(2..4,5..7))
    assert_equal(true, equal_by_trans?(U1d[2..4,5..7],U1d[4..6,7..9]))
    assert_equal(true, equal_by_trans?(R2d[2..4,5..7],R2d[4..6,9..11]))
    assert_equal(true, equal_by_trans?(U2d[U2d[R2d[2..3,2..3],R2d[3..4,3..4]],R2d[4..5,5..6]],U2d[U2d[R2d[3..4,1..2],R2d[4..5,2..3]],R2d[5..6,4..5]]))
    assert_equal(false, equal_by_trans?(R2d[2..3,2..3],U1d[2..3,2..3]))
    assert_equal(false, equal_by_trans?(U1d[2..3,U1d[3..4,4..5]],U1d[U1d[3..4,4..5],2..3]))
    assert_equal(false, equal_by_trans?(R2d[2..4,0..0],2..4))
  end
end
