# Aufgabe 1: Berechnen des Volumens eines n-dimensionalen Hohlwuerfels

$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'

# Spezifikation
# Volume of a n-dimensional hollow cube:
# hollow_cube_vol ::= Nat x Nat x Nat ->? Nat::
# (l_outer, l_inner, dimension) :::: l_outer > l_inner; dimension > 0 ::::
#    l_outer ** dimension - l_inner ** dimension ::
# Tests:
# { [1,0,5] => 1; [-1,-1,3] => Err; [0,0,3] => Err; [0,1,3] => Err;
# ["3","1" => Err; [2,1,3] => 7; [3,2,3] => 19; [3,2,0] => Err; [5,3,1] => 2}

def hollow_cube_vol(l_outer, l_inner, dimension = 3)
  check_pre((l_outer.nat? and l_inner.nat? and l_outer > l_inner and dimension.int_pos?))
  cube_vol(l_outer, dimension) - cube_vol(l_inner, dimension)
end

# in hollow_cube_vol:(l_outer**3 - l_inner**3)
# -> refactured to its own function
def cube_vol(length, dimension = 3)
  check_pre((length.nat? and dimension.int_pos?))
  length**dimension
end