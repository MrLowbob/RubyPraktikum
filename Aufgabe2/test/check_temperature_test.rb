# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'check_temperature'

class CheckTemperatureTest < Test::Unit::TestCase

  def test_zu_kalt?
    assert_equal(true, zu_kalt?(-10))
    assert_equal(false, zu_kalt?(16))
    assert_equal(false, zu_kalt?(20))
    
    #checks:
    assert_raise(RuntimeError) {zu_kalt?("20")}
    assert_raise(RuntimeError) {zu_kalt?(18.5)}
    assert_raise(RuntimeError) {zu_kalt?(-274)}
  end
  
  def test_zu_warm?
    assert_equal(false, zu_warm?(-10))
    assert_equal(false, zu_warm?(22))
    assert_equal(true, zu_warm?(40))
    
    #checks:
    assert_raise(RuntimeError) {zu_warm?("20")}
    assert_raise(RuntimeError) {zu_warm?(18.5)}
    assert_raise(RuntimeError) {zu_warm?(-274)}
  end
  
  def test_angenehm?
    assert_equal(false, angenehm?(-10))
    assert_equal(true, angenehm?(22))
    assert_equal(true, angenehm?(16))
    assert_equal(true, angenehm?(22))
    assert_equal(false, angenehm?(40))
    
    #checks:
    assert_raise(RuntimeError) {angenehm?("20")}
    assert_raise(RuntimeError) {angenehm?(18.5)}
    assert_raise(RuntimeError) {angenehm?(-274)}
  end
  
  def test_unangenehm?
    assert_equal(true, unangenehm?(-10))
    assert_equal(false, unangenehm?(22))
    assert_equal(false, unangenehm?(16))
    assert_equal(false, unangenehm?(22))
    assert_equal(true, unangenehm?(40))
    
    #checks:
    assert_raise(RuntimeError) {unangenehm?("20")}
    assert_raise(RuntimeError) {unangenehm?(18.5)}
    assert_raise(RuntimeError) {unangenehm?(-274)}
  end
end
