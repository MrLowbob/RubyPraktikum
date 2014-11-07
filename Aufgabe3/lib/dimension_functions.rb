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
  else    check_pre(false)
  end
end

def shape1d_include?(shape, point)
  if    range1d?(shape) then shape.include?(point)
  elsif union1d?(shape) then 
    shape1d_include?(shape.left,  point) or 
    shape1d_include?(shape.right, point)
  end
end

def shape2d_include?(shape2d, point2d)
  
end

def trans1d(union, int)
  check_pre((union.shape1d? and int.int?))
  if      range1d?(union) then range_int(union, int)
  elsif   union.union1d?  then trans1d(union.left) and trans1d(union.right)
  else    check_pre(false)
  end
end

def range_int(range, int)
  (trans_p1d(range.first,int)..trans_p1d(range.last,int))
end

def trans_p1d(point, vektor)
  point + vektor
end
