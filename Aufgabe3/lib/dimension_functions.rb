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
  elsif   shape.union2d? or shape.range2d? and point.point2d?
    then  shape2d_include?(shape, point)
  else    check_pre(false)
  end
end

def shape1d_include?(shape, point)
  if      range1d?(shape) then shape.include?(point)
  elsif   union1d?(shape) then 
    shape1d_include?(shape.left,  point) or 
    shape1d_include?(shape.right, point)
  else check_pre(false)
  end
end

def shape2d_include?(shape2d, point2d)
  if    shape2d.range2d? then 
    shape2d.range1.include?(point2d.x) and
    shape2d.range2.include?(point2d.y)
  elsif shape2d.union2d? then
     shape2d_include?(shape2d.left, point2d) or
     shape2d_include?(shape2d.right, point2d)
  else check_pre(false)
  end
end

#translate ::= (shape, point) :: Shape x Point->? Shape
def translate(shape, point)
  if       shape1d?(shape) and point.int?     then trans1d(shape, point)
  elsif    shape2d?(shape) and point.point2d? then trans2d(shape, point)
  else     check_pre(false)    
  end
end

#trans1d ::= (shape, point) :: Shape x Point->?Shape
def trans1d(shape, point)
  if      range1d?(shape)
    range_int(shape, point)
  elsif   shape.union1d? 
    Union1d[trans1d(shape.left), trans1d(shape.right)]
  else    check_pre(false)
  end
end

def trans2d(shape, point)
  if      shape.range2d?
      Range2d[range_int(shape.range1, point.x), range_int(shape.range2, point.y)]
  elsif   shape.union2d?
      Union2d[trans2d(shape.left,  point), trans2d(shape.right, point)]
  else    check_pre((false))
  end
end

def range_int(range, int)
  if   range1d?(range)
    (trans_p1d(range.first,int)..trans_p1d(range.last,int))
  else check_pre(false)
  end
end

def trans_p1d(point, vektor)
  point + vektor
end

#bounding_range ::= (r1,r2) :: (Range1d x Range1d) -> Range1d | (Range2d x Range2d) -> Range2d
def bounding_range(r1, r2)
  if      range1d?(r1) and range1d?(r2)
    bounding1d(r1,r2)
  elsif   r1.range2d? and r2.range2d?
    bounding2d(r1,r2)
  else    check_pre(false)
  end
end

def bounding1d(r1, r2)
  first = (r1.first > r2.first) ? r2.first : r1.first
  last  = (r1.last > r2.last) ? r1.last : r2.last
  
  range_it(first, last)
end

def bounding2d(r1, r2)
  range1 = bounding1d(r1.range1, r2.range1) and
  range2 = bounding1d(r1.range2, r2.range2)
  Range2d[range1, range2]
end

def range_it(first, last)
  (first..last)
end

#bounds ::= (shape) :: Shape ->(Range1d | Range2d)
def bounds(shape)
  if    range1d?(shape) or shape.range2d? then shape
  elsif shape.union1d? then bounding_range(bounds(shape.left), bounds(shape.right))
  elsif shape.union2d? then bounding_range(bounds(shape.left), bounds(shape.right))
  else  check_pre(false)
  end
end

#equal_by_dim? ::= GraphObj x GraphObj -> Bool
def equal_by_dim?(obj1, obj2)
  check_pre((graphobj?(obj1) and graphobj?(obj2))) 
  (dim1?(obj1) and dim1?(obj2)) or (dim2?(obj1) and dim2?(obj2))
end

def dim1?(obj1)
  range1d?(obj1) or obj1.union1d? or obj1.int?
end

def dim2?(obj1)
  shape2d?(obj1) or obj1.point2d?
end

#equal_by_tree? ::= GraphObj x GraphObj -> Bool
def equal_by_tree?(obj1, obj2)
  check_pre((equal_by_dim?(obj1, obj2)))
  if dim1?(obj1) 
    if    obj1 == obj2
      true
    elsif obj1.int? and obj2.int?
      true
    elsif obj1.union1d? and obj2.union1d?
      equal_by_tree?(obj1.left, obj2.left) and equal_by_tree?(obj1.right, obj2.right)
    elsif range1d?(obj1) and range1d?(obj2)
      true
    else  false  
    end
    
  elsif dim2?(obj1)
     if    obj1 == obj2
      true
    elsif obj1.union2d? and obj2.union2d?
      equal_by_tree?(obj1.left, obj2.left) and 
      equal_by_tree?(obj1.right, obj2.right)
    elsif obj1.range2d? and obj2.range2d?
      equal_by_tree?(obj1.range1, obj2.range1) and 
      equal_by_tree?(obj1.range2, obj2.range2)
    elsif obj1.point2d? and obj2.point2d?
      true
    else  false  
    end
  else check_pre(false)  
  end
end

#equal_by_trans? ::= GraphObj x GraphObj -> Bool
def equal_by_trans(obj1, obj2)
  check_pre((equal_by_dim?(obj1, obj2)))
  check_pre((equal_by_tree?(obj1, obj2)))
  if bounds(obj1) == bounds(obj2)
    if dim1?(obj1)
      min1d(obj1) + x = min1d(obj2)
      grapho1 = translate(obj2, x)
      obj1 == grapho1
    elsif dim2?(obj1)
      min2d(obj1) + x = min2d(obj2)
      grapho1 = translate(obj2, x)
      obj1 == grapho1
    end
  else false  
  end
end

def min1d(point)
  if range1d?(point)
    point.first
  elsif point.union1d? 
    point.left.first > point.right.first ? min1d(point.right) : min1d(point.left)
  elsif point.int?
    point
  else check_pre(false)
  end
end

def min2d(point)
  if point.point2d?
    point.x
  elsif point.range2d? 
    min1d(point.range1) > min1d(point.range2) ? min1d(point.range2) : min1d(point.range1)
  elsif point.union2d?
    min2d(point.left) > min2d(point.right) ? min2d(point.right) : min2d(point.left)
  else check_pre(false)
  end
end