# Aufgabe2: Schreiben Sie je eine Funktion, die den höheren, bzw den niedrigeren Parameter zurückgibt.
# sowie eine Funktion, die kontrolliert, ob ein Wert in einem Bereich ist.

$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'

# Spezification
# return Minimum of 2 arguments:
# min_int ::= Int x Int ->? Int ::
# (int1, int2) :::: int1 < int2 -> int1 :::: int1 > int2 -> int2 ::
# Tests { [1,0] => 0; [0,-1] => -1; [-2,2] => -2; [5,2] => 2;
# ["1",0] => Err; [1,1] => 1; [1.5,2] => Err; }

#Zwei gleichgroße Zahlen sind aufgrund der Aufgabe larger_sum_square zugelassen.
def min_int(int1, int2) 
  check_pre((int1.int? and int2.int?))
  (int1 > int2) ? int2 : int1
end

# Spezification
# return Maximum of 2 arguments:
# min_int ::= Int x Int ->? Int ::
# (int1, int2) :::: int1 > int2 -> int1 :::: int1 < int2 -> int2 ::
# Tests { [1,0] => 1; [0,-1] => 0; [-2,2] => 2; [5,2] => 5;
# ["1",0] => Err; [1,1] => 1; [1.5,2] => Err; }

def max_int(int1, int2) 
  check_pre((int1.int? and int2.int?))
  (int1 < int2) ? int2 : int1
end


# Spezifcaton:
# check if a number is within a range
# within? ::= Int x Int x Int ->? bool ::
# (val, lower, upper) :::: lower <= upper :::: lower <= val <= upper -> true :::: val < lower -> false ::::
# val > upper -> false ::
# Tests { [1,0,4] => true; [-2,-5,2] => true; [1,1,2] => true; [2,1,2] => true; [1,2,3] => false; [2,2,2] => true;
# [3,1,2] => false; ["3",2,4] => Err; [3.2,2,5] => Err; 

def within?(val, lower, upper)
  check_pre((val.int? and lower.int? and upper.int? and lower <= upper))
  (val >= lower and val <= upper) ? true : false
end
