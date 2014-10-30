$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'hollow_cube'

class HollowCubeTest < Test::Unit::TestCase
  
  def test_hollow_cube
    assert_equal(1, hollow_cube_vol(1,0))
    assert_equal(7, hollow_cube_vol(2,1))
    assert_equal(19, hollow_cube_vol(3,2))
  end
  
  def test_hollow_cube_checks
    assert_raise(RuntimeError) {hollow_cube_vol(3,-2)}
    assert_raise(RuntimeError) {hollow_cube_vol(-1,-1)}
    assert_raise(RuntimeError) {hollow_cube_vol(0,0)}
    assert_raise(RuntimeError) {hollow_cube_vol(0,1)}
    assert_raise(RuntimeError) {hollow_cube_vol("3","1")}
    
  end
end

# [1,0] => 1; [-1,-1] => Err; [0,0] => Err; [0,1] => Err;
# ["3","1" => Err; [2,1] => 7; [3,2] => 19