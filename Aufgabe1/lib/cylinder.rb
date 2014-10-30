# Aufgabe 3: Berechnen des Volumens eines Zylinders

$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'

# Spezification
# volume of a cylinder
# cylinder_vol ::= Float x Float ->? Float::
# (radius, height) :::: radius > 0; height > 0 ::::
# PI * radius**2 * height ::
# Tests:
# {[0.0,1.0] => Err; [1.0,0.0] => Err; [-1.0,1.0] => Err; [1.0,-1.0] => Err; ["1.0","1.0"] => Err;
# [1,1] => Err;
# [1.0,1.0] =>  3,1415926535; [3.0,3.0] => 84,8230016469; [1.5, 1.5] => 10.6028752058}

def cylinder_vol(radius, height)
  check_pre((radius.float_pos? and height.float_pos?))
  (radius ** 2) * Math::PI * height
end