# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'day'

class DayTest < Test::Unit::TestCase
  def test_day_num?
    assert_equal(true, day_num?(1))
    assert_equal(true, day_num?(3))
    assert_equal(false, day_num?(8))
    assert_equal(false, day_num?(0))
    assert_equal(false, day_num?(:Mo))
  end
  
  def test_day_sym?
    assert_equal(true, day_sym?(:Mo))
    assert_equal(true, day_sym?(:Fr))
    assert_equal(false, day_sym?(3))
    assert_equal(false, day_sym?(:Ab))
    assert_equal(false, day_sym?("Klaus"))
  end
  
  def test_day?
    assert_equal(true, day?(2))
    assert_equal(true, day?(5))
    assert_equal(true, day?(:Mo))
    assert_equal(true, day?(:So))
    assert_equal(false, day?(0))
    assert_equal(false, day?(:Aa))
    assert_equal(false, day?("Fr"))
  end
  
  def test_day_num_to_day_sym
    assert_equal(:Mo, day_num_to_day_sym(1))
    assert_equal(:So, day_num_to_day_sym(7))
    #checks
    assert_raise(RuntimeError) {(day_num_to_day_sym(8))}
    assert_raise(RuntimeError) {(day_num_to_day_sym(:Mo))}
    assert_raise(RuntimeError) {(day_num_to_day_sym("Fr"))}
  end
  
  def test_day_sym_to_day_num
    assert_equal(2, day_sym_to_day_num(:Di))
    assert_equal(6, day_sym_to_day_num(:Sa))
    #checks
    assert_raise(RuntimeError) {(day_sym_to_day_num(3))}
    assert_raise(RuntimeError) {(day_sym_to_day_num(:Ab))}
    assert_raise(RuntimeError) {(day_sym_to_day_num("Fr"))}
  end
  
  def test_to_day_sym
    assert_equal(:Mo, to_day_sym(1))
    assert_equal(:Di, to_day_sym(:Di))
    assert_equal(:So, to_day_sym(7))
    #checks
    assert_raise(RuntimeError) {to_day_sym(8)}
    assert_raise(RuntimeError) {to_day_sym(:Ab)}
    assert_raise(RuntimeError) {to_day_sym("hans")}
  end
  
  def test_to_day_num
    assert_equal(2, to_day_num(:Di))
    assert_equal(1, to_day_num(1))
    assert_equal(7, to_day_num(:So))
    #checks
    assert_raise(RuntimeError) {to_day_num(8)}
    assert_raise(RuntimeError) {to_day_num(:Ab)}
    assert_raise(RuntimeError) {to_day_num("hans")}
  end
  
  def test_day_num_succ
    assert_equal(2, day_num_succ(1))
    assert_equal(3, day_num_succ(2))
    assert_equal(1, day_num_succ(7))
    #checks
    assert_raise(RuntimeError) {day_num_succ(:Mo)}
    assert_raise(RuntimeError) {day_num_succ(0)}
    assert_raise(RuntimeError) {day_num_succ(8)}
  end
  
  def test_day_num_pred
    assert_equal(7, day_num_pred(1))
    assert_equal(1, day_num_pred(2))
    assert_equal(6, day_num_pred(7))
    #checks
    assert_raise(RuntimeError) {day_num_pred(:Mo)}
    assert_raise(RuntimeError) {day_num_pred(0)}
    assert_raise(RuntimeError) {day_num_pred(8)}
  end
  
  def test_day_sym_succ
    assert_equal(:Mo, day_sym_succ(:So))
    assert_equal(:Mi, day_sym_succ(:Di))
    assert_equal(:Di, day_sym_succ(:Mo))
    #checks
    assert_raise(RuntimeError) {day_sym_succ(3)}
    assert_raise(RuntimeError) {day_sym_succ(:AA)}
    assert_raise(RuntimeError) {day_sym_succ("Klaus")}
  end
  
  def test_day_sym_pred
    assert_equal(:Mo, day_sym_pred(:Di))
    assert_equal(:Sa, day_sym_pred(:So))
    assert_equal(:So, day_sym_pred(:Mo))
    #checks
    assert_raise(RuntimeError) {day_sym_pred(3)}
    assert_raise(RuntimeError) {day_sym_pred("0")}
    assert_raise(RuntimeError) {day_sym_pred(:AA)}
  end
  
  def test_day_succ
    assert_equal(:Mo, day_succ(:So))
    assert_equal(:Mi, day_succ(:Di))
    assert_equal(:Di, day_succ(:Mo))
    assert_equal(2, day_succ(1))
    assert_equal(3, day_succ(2))
    assert_equal(1, day_succ(7))
    #checks
    assert_raise(RuntimeError) {day_succ("0")}
    assert_raise(RuntimeError) {day_succ(:AA)}
    assert_raise(RuntimeError) {day_succ(8)}
  end
  
  def test_day_pred
    assert_equal(:Sa, day_pred(:So))
    assert_equal(:Mo, day_pred(:Di))
    assert_equal(:So, day_pred(:Mo))
    assert_equal(7, day_pred(1))
    assert_equal(1, day_pred(2))
    assert_equal(6, day_pred(7))
    #checks
    assert_raise(RuntimeError) {day_pred("0")}
    assert_raise(RuntimeError) {day_pred(:AA)}
    assert_raise(RuntimeError) {day_pred(8)}
  end
end