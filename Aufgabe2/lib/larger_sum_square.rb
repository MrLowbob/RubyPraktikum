#Aufgabe2.3: Aus 3 Zahlen die größeren beiden finden und diese quadrieren und dann addieren

#$:.unshift File.join(File.dirname(__FILE__),'..','lib') 
# normales starten geht nicht, wenn obige Zeile auskommentiert ist
# im Test aber schon? wo ist der unterschied?
require 'conditional_operations'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'


# Specification
# get the two biggest numbers out of 3, add their squares
# larger_sum_square ::= Int x Int x Int -> Nat ::
# (val1, val2, val3) :::: max_int(val1, val2), max_int(val3, min_int(val1, val2) -> [max1, max2] :::: max1 ** 2 + max2 ** 2 ::
# Test {[1,2,3] => 13; [1,3,2] => 13; [2,3,1] => 13; [2,1,3] => 13; [3,1,2] => 13; [3,2,1] => 13; 
# [-1,-2,-3] => 5; [2,2,2] => 8; ["2",2,2] => Err; [2.5,2,2] => Err;}

def larger_sum_square(val1, val2, val3)
  check_pre((val1.int? and val2.int? and val3.int?))
  a,b = larger_numbers(val1, val2, val3)
  square(a) + square(b)
end

def square(x)
  x**2
end

def larger_numbers(val1, val2, val3)
  check_pre((val1.int? and val2.int? and val3.int?))
  #[max_int(min_int(val1, val2), val3), max_int(val1, val2)]
  
  #kürzere (kürzeste) Rechenzeit
  (val1 >= val2) ? [((val2 >= val3) ? val2 : val3), val1] : [((val1 >= val3) ? val1 : val3), val2]
end