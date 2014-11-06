$:.unshift File.join(File.dirname(__FILE__),'..','lib')
require 'eins_d'
require 'zwei_d'
require 'n_d'

$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'


#shape_include? ::= (shape,point) :: Shape x Point->?Bool
def shape_include?(shape, point)
  if      shape.union1d? or range1d?(shape) and point.int?
    then  shape1d_include?(shape, point)
  elsif   shape.union2d? and point.point2d?
    then  shape2d_include?(shape, point)
  else check_pre((false))
  end
end

def shape1d_include?(shape, point)
  
end

def shape2d_include?(shape, point)
  
end