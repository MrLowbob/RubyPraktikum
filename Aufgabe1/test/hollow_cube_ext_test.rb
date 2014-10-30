$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'hollow_cube_ext'

class HollowCubeTest < Test::Unit::TestCase
  
  def test_hollow_cube
    assert_equal(1, hollow_cube_vol(1,0,5))
    assert_equal(7, hollow_cube_vol(2,1,3))
    assert_equal(19, hollow_cube_vol(3,2,3))
    assert_equal(2, hollow_cube_vol(5,3,1))
  end
  
  def test_hollow_cube_checks
    assert_raise(RuntimeError) {hollow_cube_vol(3,-2,3)}
    assert_raise(RuntimeError) {hollow_cube_vol(-1,-1,3)}
    assert_raise(RuntimeError) {hollow_cube_vol(0,0,3)}
    assert_raise(RuntimeError) {hollow_cube_vol(0,1,3)}
    assert_raise(RuntimeError) {hollow_cube_vol("3","1","3")}
    assert_raise(RuntimeError) {hollow_cube_vol(1,0,-1)}
    assert_raise(RuntimeError) {hollow_cube_vol(3,2,0)}  
  end
end

# Tests:
# { [1,0,5] => 1; [-1,-1,3] => Err; [0,0,3] => Err; [0,1,3] => Err;
# ["3","1","3"] => Err; [2,1,3] => 7; [3,2,3] => 19; [3,2,0] => Err; [5,3,1] => 2
# [1,0,-1] => Err}