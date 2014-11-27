# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'graphics_classes'

P1D = Point1d
R1D = Range1d 
U1D = Union1d 
P2D = Point2d 
R2D = Range2d
U2D = Union2d

class Graphics_classes_test < Test::Unit::TestCase
  def test_shape_include?
    #1D
    assert_equal(true, U1D[R1D[P1D[1],P1D[3]],R1D[P1D[5],P1D[7]]].shape_include?(P1D[2]))
    assert_equal(true, R1D[P1D[2],P1D[4]].shape_include?(P1D[3]))
    
    #2D
    assert_equal(true, R2D[R1D[P1D[3],P1D[8]],R1D[P1D[3],P1D[6]]].shape_include?(P2D[P1D[3],P1D[5]]))
    assert_equal(false, R2D[R1D[P1D[3],P1D[8]],R1D[P1D[8],P1D[3]]].shape_include?(P2D[P1D[3],P1D[76]]))

    assert_equal(true, U2D[R2D[R1D[P1D[3],P1D[8]],R1D[P1D[3],P1D[6]]], R2D[R1D[P1D[15],P1D[20]],R1D[P1D[30],P1D[31]]]].shape_include?(P2D[P1D[16],P1D[30]]))
    assert_equal(false, U2D[R2D[R1D[P1D[3],P1D[8]],R1D[P1D[3],P1D[6]]], R2D[R1D[P1D[15],P1D[20]],R1D[P1D[30],P1D[31]]]].shape_include?(P2D[P1D[14],P1D[30]]))
    assert_equal(true, U2D[R2D[R1D[P1D[3],P1D[8]],R1D[P1D[3],P1D[6]]], U2D[R2D[R1D[P1D[3],P1D[8]],R1D[P1D[3],P1D[6]]], R2D[R1D[P1D[4],P1D[401]],R1D[P1D[30],P1D[31]]]]].shape_include?(P2D[P1D[14],P1D[30]]))
  end
  
  def test_translate
    #1D
    assert_equal(P1D[1], P1D[3].translate(P1D[-2]))
    assert_equal(R1D[P1D[7], P1D[14]], R1D[P1D[5], P1D[12]].translate(P1D[2]))
    assert_equal(U1D[R1D[P1D[7],P1D[9]],R1D[P1D[11],P1D[13]]], U1D[R1D[P1D[4],P1D[6]],R1D[P1D[8],P1D[10]]].translate(P1D[3]))
    
    #2D
    assert_equal(P2D[P1D[24], P1D[26]], P2D[P1D[4], P1D[5]].translate(P2D[P1D[20],P1D[21]]))
    assert_equal(R2D[R1D[P1D[6],P1D[11]], R1D[P1D[-2],P1D[0]]], R2D[R1D[P1D[3],P1D[8]],R1D[P1D[3],P1D[5]]].translate(P2D[P1D[3],P1D[-5]]))
    assert_equal(U2D[ R2D[R1D[P1D[3],P1D[10]],R1D[P1D[11],P1D[16]]], R2D[R1D[P1D[0],P1D[5]], R1D[P1D[11],P1D[16]]]], U2D[ R2D[R1D[P1D[6],P1D[13]],R1D[P1D[6],P1D[11]]], R2D[R1D[P1D[3],P1D[8]], R1D[P1D[6],P1D[11]]]].translate(P2D[P1D[-3], P1D[5]]))
    assert_equal(U2D[R2D[R1D[P1D[4],P1D[13]],R1D[P1D[16],P1D[21]]],R2D[R1D[P1D[5],P1D[11]],R1D[P1D[9],P1D[30]]]], U2D[R2D[R1D[P1D[1],P1D[10]],R1D[P1D[11],P1D[16]]],R2D[R1D[P1D[2],P1D[8]],R1D[P1D[4],P1D[25]]]].translate(P2D[P1D[3],P1D[5]]))
  end
    
  def test_bounds
    #1D
    assert_equal(R1D[P1D[3],P1D[7]], R1D[P1D[3],P1D[7]].bounds)
    assert_equal(R1D[P1D[2], P1D[5]], U1D[R1D[P1D[2], P1D[3]], R1D[P1D[4], P1D[5]]].bounds)
    assert_equal(R1D[P1D[1], P1D[19]], U1D[R1D[P1D[1], P1D[3]], U1D[R1D[P1D[2], P1D[3]], R1D[P1D[13], P1D[19]]]].bounds)
    
    #2D
    assert_equal(R2D[R1D[P1D[3],P1D[10]], R1D[P1D[9],P1D[16]]], U2D[ R2D[R1D[P1D[3],P1D[10]],R1D[P1D[11],P1D[16]]],R2D[R1D[P1D[3],P1D[10]],R1D[P1D[9],P1D[16]]]].bounds)
    assert_equal(R2D[R1D[P1D[1],P1D[10]], R1D[P1D[4],P1D[25]]], U2D[ R2D[R1D[P1D[3],P1D[10]],R1D[P1D[11],P1D[16]]],U2D[ R2D[R1D[P1D[1],P1D[10]],R1D[P1D[11],P1D[16]]],R2D[R1D[P1D[2],P1D[8]],R1D[P1D[4],P1D[25]]]]].bounds)
  end
  
  def test_equals
    assert_equal(true, P1D[1].equal_by_dim?(R1D[P1D[4], P1D[8]]))
    assert_equal(false, P1D[3].equal_by_dim?(R2D[R1D[P1D[1],P1D[10]], R1D[P1D[4],P1D[25]]]))
    assert_equal(true, U2D[R2D[R1D[P1D[1],P1D[10]],R1D[P1D[11],P1D[16]]],R2D[R1D[P1D[2],P1D[8]],R1D[P1D[4],P1D[25]]]].equal_by_dim?(P2D[P1D[2], P1D[4]]))
    
    assert_equal(true, R1D[P1D[43],P1D[46]].equal_by_tree?(R1D[P1D[43],P1D[46]]))
    assert_equal(true, R2D[R1D[P1D[1],P1D[10]],R1D[P1D[11],P1D[16]]].equal_by_tree?(R2D[R1D[P1D[1],P1D[10]],R1D[P1D[11],P1D[16]]]))
    assert_equal(false,R2D[R1D[P1D[1],P1D[10]],R1D[P1D[11],P1D[16]]].equal_by_tree?(R2D[R1D[P1D[1],P1D[10]],R1D[P1D[11],P1D[15]]]))
    assert_equal(true, U2D[R2D[R1D[P1D[1],P1D[10]],R1D[P1D[11],P1D[16]]],R2D[R1D[P1D[2],P1D[8]],R1D[P1D[4],P1D[25]]]].equal_by_tree?(U2D[R2D[R1D[P1D[1],P1D[10]],R1D[P1D[11],P1D[16]]],R2D[R1D[P1D[2],P1D[8]],R1D[P1D[4],P1D[25]]]]))
  end
  
  def test_shift
   #1D
    assert_equal(P1D[-6], R1D[P1D[3],P1D[5]].shift(R1D[P1D[9],P1D[10]]))
    assert_equal(P1D[0],  U1D[R1D[P1D[1], P1D[3]], U1D[R1D[P1D[2], P1D[3]], R1D[P1D[13], P1D[19]]]].shift(U1D[R1D[P1D[1], P1D[3]], U1D[R1D[P1D[3], P1D[4]], R1D[P1D[14], P1D[20]]]]))
    
   #2D
    assert_equal(P2D[P1D[-7],P1D[-2]], R2D[R1D[P1D[3],P1D[9]],R1D[P1D[1],P1D[12]]].shift(R2D[R1D[P1D[10],P1D[16]],R1D[P1D[3],P1D[14]]]))
    assert_equal(P2D[P1D[-19],P1D[-2]], R2D[R1D[P1D[1],P1D[10]],R1D[P1D[11],P1D[14]]].shift(R2D[R1D[P1D[20],P1D[19]],R1D[P1D[13],P1D[17]]]))
    assert_equal(P2D[P1D[-1],P1D[3]], U2D[R2D[R1D[P1D[1],P1D[10]],R1D[P1D[11],P1D[16]]],R2D[R1D[P1D[2],P1D[8]],R1D[P1D[4],P1D[25]]]].shift(U2D[R2D[R1D[P1D[3],P1D[4]],R1D[P1D[12],P1D[90]]],R2D[R1D[P1D[2],P1D[19]],R1D[P1D[1],P1D[2]]]]))
    assert_equal(P2D[P1D[0],P1D[0]], U2D[R2D[R1D[P1D[1],P1D[10]],R1D[P1D[11],P1D[16]]],R2D[R1D[P1D[2],P1D[8]],R1D[P1D[4],P1D[25]]]].shift(U2D[R2D[R1D[P1D[1],P1D[10]],R1D[P1D[11],P1D[16]]],R2D[R1D[P1D[2],P1D[8]],R1D[P1D[4],P1D[25]]]]))
   end
  
  def test_equal_by_trans
    #1D
    assert_equal(true, P1D[3].equal_by_trans?(P1D[5]))
    assert_equal(false,P1D[1].equal_by_trans?(R1D[P1D[8], P1D[9]]))
    assert_equal(false,R1D[P1D[3],P1D[9]].equal_by_trans?(R1D[P1D[2],P1D[10]]))
    assert_equal(true, R1D[P1D[10],P1D[12]].equal_by_trans?(R1D[P1D[11],P1D[13]]))
    assert_equal(true, U1D[R1D[P1D[0],P1D[1]],R1D[P1D[8],P1D[14]]].equal_by_trans?(U1D[R1D[P1D[3],P1D[4]], R1D[P1D[11],P1D[17]]]))
  
    #2D
    assert_equal(false, P2D[P1D[4], P1D[2]].equal_by_trans?(P1D[4]))
    assert_equal(false, P2D[P1D[6],P1D[8]].equal_by_trans?(P2D[P1D[7], P1D[16]]))
    assert_equal(true,  R2D[R1D[P1D[3],P1D[9]], R1D[P1D[1],P1D[12]]].equal_by_trans?(R2D[R1D[P1D[10],P1D[16]], R1D[P1D[3],P1D[14]]]))
    assert_equal(false, R2D[R1D[P1D[8],P1D[14]], R1D[P1D[1],P1D[12]]].equal_by_trans?(R2D[R1D[P1D[13], P1D[20]], R1D[P1D[200], P1D[14]]]))
    assert_equal(true , U2D[R2D[R1D[P1D[1],P1D[10]],R1D[P1D[11],P1D[16]]],R2D[R1D[P1D[2],P1D[8]],R1D[P1D[4],P1D[25]]]].equal_by_trans?(U2D[R2D[R1D[P1D[3],P1D[12]],R1D[P1D[13],P1D[18]]],R2D[R1D[P1D[4],P1D[10]],R1D[P1D[6],P1D[27]]]]))
    assert_equal(false, U2D[R2D[R1D[P1D[1],P1D[10]],R1D[P1D[11],P1D[16]]],R2D[R1D[P1D[2],P1D[8]],R1D[P1D[4],P1D[25]]]].equal_by_trans?(U2D[R2D[R1D[P1D[20],P1D[13]],R1D[P1D[13],P1D[15]]],R2D[R1D[P1D[9],P1D[79]],R1D[P1D[20],P1D[30]]]]))
  end
end
