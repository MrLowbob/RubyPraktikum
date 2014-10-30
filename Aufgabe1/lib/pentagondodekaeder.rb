# Berechnen Sie die Oberfläche eines Pentagondodekaeders

$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'

# Specification
# Calculate the surface of a regular dodecahedron
# regular_dodecahedron_surface ::= Float ->? Float ::
# (edge) :::: edge < 0 :::: 3* (edge ** 2) * sqrt(25 + (10 * sqrt(5))) ::
# Tests:
# {[1.0] => 18,33701497; [2.5] => 114.6063436; 
# [0.0] => Err; [-2.0] => Err; ["1.0"] => Err; [1] => Err}

$CONSTANT_FACTOR_REG_DODECAHEDRON_SUR = 3.0 * (15.0 + 10.0 * (5.0 ** 0.5)) ** 0.5

def regular_dodecahedron_surface(edge)
  check_pre((edge.float_pos?))
  (edge ** 2.0) * $CONSTANT_FACTOR_REG_DODECAHEDRON_SUR
end