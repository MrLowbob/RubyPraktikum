# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'larger_sum_square'

class LargerSumSquareTest < Test::Unit::TestCase
  def test_larger_sum_square
    assert_equal(13, larger_sum_square(1,2,3))
    assert_equal(13, larger_sum_square(1,3,2))
    assert_equal(13, larger_sum_square(2,3,1))
    assert_equal(13, larger_sum_square(2,1,3))
    assert_equal(13, larger_sum_square(3,2,1))
    assert_equal(13, larger_sum_square(3,1,2))
    assert_equal(8, larger_sum_square(2,2,2))
    assert_equal(5, larger_sum_square(-1,-2,-3))
    
    #checks
    assert_raise(RuntimeError) {larger_sum_square("2",2,2)}
    assert_raise(RuntimeError) {larger_sum_square(2.5,2,2)}
  end
  
  def test_larger_numbers
    assert_equal([3,2],larger_numbers(1,2,3))
    assert_equal([2,3],larger_numbers(3,1,2))
    assert_equal([2,3],larger_numbers(2,3,1))
  end
end
