# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'conditional_operations'

class ConditionalOperationsTest < Test::Unit::TestCase
  #Tests for min_int
  def test_min_int
    assert_equal(0, min_int(1,0))
    assert_equal(-1, min_int(0,-1))
    assert_equal(-2, min_int(-2,2))
    assert_equal(2, min_int(5,2))
    assert_equal(1, min_int(1,1))
  end
  
  def test_min_int_checks
    assert_raise(RuntimeError) {min_int("1",0)}
    assert_raise(RuntimeError) {min_int(1.5,2)}
  end
  
  #Tests for max_int
  def test_max_int
    assert_equal(1, max_int(1,0))
    assert_equal(0, max_int(0,-1))
    assert_equal(2, max_int(-2,2))
    assert_equal(5, max_int(5,2))
    assert_equal(1, max_int(1,1))
  end
  
  def test_max_int_checks
    assert_raise(RuntimeError) {max_int("1",0)}
    assert_raise(RuntimeError) {max_int(1.5,2)}
  end
  
  #Tests for within?
  def test_within?
    assert_equal(true, within?(1,0,4))
    assert_equal(true, within?(-2,-5,-1))
    assert_equal(true, within?(1,1,2))
    assert_equal(true, within?(2,1,2))
    assert_equal(false, within?(1,2,3))
    assert_equal(false, within?(3,1,2))
    assert_equal(true, within?(2,2,2))
  
    #checks
    assert_raise(RuntimeError) {within?("3",2,4)}
    assert_raise(RuntimeError) {within?(3.2,2,5)}
  end
end
