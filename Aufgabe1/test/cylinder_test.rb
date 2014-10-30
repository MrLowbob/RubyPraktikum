

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'cylinder'

class CylinderTest < Test::Unit::TestCase
  
  DELTA = 0.0000000001
  
  def test_cylinder_vol
    assert_in_delta(3.1415926535, cylinder_vol(1.0,1.0), DELTA)
    assert_in_delta(84.8230016469, cylinder_vol(3.0,3.0), DELTA)
    assert_in_delta(10.6028752058, cylinder_vol(1.5, 1.5), DELTA)
  end
  
  def test_cylinder_vol_checks
    assert_raise(RuntimeError) {cylinder_vol(1,-1)}
    assert_raise(RuntimeError) {cylinder_vol(1.0,-1.0)}
    assert_raise(RuntimeError) {cylinder_vol(-1.0,1.0)}
    assert_raise(RuntimeError) {cylinder_vol(0.0,1.0)}
    assert_raise(RuntimeError) {cylinder_vol(1.0,0.0)}
    assert_raise(RuntimeError) {cylinder_vol("1.0","1.0")}
  end
end
