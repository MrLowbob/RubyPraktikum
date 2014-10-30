# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'clock'

class ClockTest < Test::Unit::TestCase

  def test_change_time
    assert_equal([0,0,0], change_time(0,0,0))
    assert_equal([1,1,1], change_time(1,1,1))
    assert_equal([22,58,59], change_time(-1,-1,-1))
    assert_equal([3,59,30], change_time(27,59,30))
    assert_equal([2,30,12], change_time(14,30,12,true))
    
    $CURRENT_MINUTES = 30
    $CURRENT_SECONDS = 30
    
    assert_equal([3,10,50], change_time(2,40,20))
    assert_equal([2,51,10], change_time(2,20,40))
    assert_equal([23,50,30], change_time(0,-40,0))
    
  end
  
  def test_change_time_checks
    assert_raise(RuntimeError) {change_time(1,1,1,5)}
    assert_raise(RuntimeError) {change_time("0",0,0)}
    assert_raise(RuntimeError) {change_time(0,60,0)}
    assert_raise(RuntimeError) {change_time(0,0,60)}
    assert_raise(RuntimeError) {change_time(0,-60,0)}
    assert_raise(RuntimeError) {change_time(0,0,-60)}
  end
  
  def test_clock_add
    assert_equal([2,30,30], clock_add(1,40,30,0,50,0,24))
    assert_equal([0,30,30], clock_add(23,40,30,0,50,0,24))
    assert_equal([5,30,30], clock_add(1,40,30,3,50,0,24))
    assert_equal([2,31,20], clock_add(1,40,30,0,50,50,24))
    assert_equal([2,31,20], clock_add(1,40,30,0,50,50,24))
    assert_equal([1,30,30], clock_add(1,30,30,12,0,0,12))
    assert_equal([1,30,30], clock_add(1,30,30,9,0,0,3))
    assert_equal([2,30,30], clock_add(5,10,10,-2,-39,-40,12))
    #checks
    assert_raise(RuntimeError) {clock_add("0",1,1,1,1,1,24)}
  end
end

# [0,0,0,false] => [0,0,0], [-1,-1,-1,false] => [22,58,59];
# [0,60,0,false] => Err, [0,0,60,false] => Err; [0,-60,0,false] => Err, [0,0,-60,false] => Err;
# [1,1,1,5] => Err; [1,1,"1",false] => Err
# [1,1,1,false] => [1,1,1], [27,59,30,false] => [3,59,30]; [14,30,12,true] => [2,30,12]}
# für ($CURRENT_MINUTES = 30, $CURRENT_SECONDS = 30)
# {[2,40,20,false] => [3,10,50]; [2,20,40,false] => [2,51,10]; [0,-40,0,false] => [23,50,30]}