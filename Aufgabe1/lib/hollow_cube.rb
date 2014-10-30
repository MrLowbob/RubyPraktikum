# Aufgabe 1: Berechnen des Volumens eines Hohlwuerfels

$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'

# Spezifikation
# (Line of Purpose - what does it?, Contract - Specification of Input and Output)
# perfect Specification is difficult - at least:
# which input is valid and which is invalid? 
# specification by examples
# 
# Volume of a hollow cube:
# hollow_cube_vol ::= Nat x Nat ->? Nat::        // Signatur der Funktion
# (l_outer, l_inner) :::: l_outer > l_inner :::: l_outer ** 3 - l_inner ** 3 ::  //was rein muss
# Test{ [1,0] => 1; [-1,-1] => Err; [0,0] => Err; [0,1] => Err;
# ["3","1" => Err; [2,1] => 7; [3,2] => 19 }

def hollow_cube_vol(l_outer, l_inner)
  check_pre((l_outer.nat? and l_inner.nat? and l_outer > l_inner))
  cube_vol(l_outer) - cube_vol(l_inner)
end

# in hollow_cube_vol:(l_outer**3 - l_inner**3)
# -> refactured to its own function
def cube_vol(length)
  check_pre((length.nat?))
  length**3
end