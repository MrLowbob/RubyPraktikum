
$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'

##
# 1-Dimensional graphics
##

#point1d ::= int
def point1d?(any)
  any.int?
end

#Range1d ::= range[first, last] :: Point1d x Point1d
def range1d?(o)
  o.int_range?
end

#Union1d ::= Union1d[left, right] :: shape1d x shape1d
def_class(:Union1d, [:left, :right]) {
  def invariant?
    shape1d?(left) and shape1d?(right)
  end
}

#Shape1d ::= Range1d | Union1d
def shape1d?(o)
  o.union1d? or range1d?(o)
end

##
# 2-Dimensional graphics
##

#Point2d ::= Point1d x Point1d
def_class(:Point2d,[:x, :y]) {
  def invariant? 
    point1d?(x) and point1d?(y)
  end
}
#Range2d ::= Range2d[x_range, y_range] :: Range1d x Range1d
def_class(:Range2d,[:x_range, :y_range]){
  def invariant?
    range1d?(x_range) and range1d?(y_range)
  end
}

#Union2d ::= Union2d[left, right] :: Shape2d x Shape2d
def_class(:Union2d,[:left, :right]){
  def invariant?
    shape2d?(left) and shape2d?(right)
  end
}

#Shape2d ::= Range2d | Union2d
def shape2d?(o)
  o.range2d? or o.union2d?
end

##
# Dimensionsunabhängig
##

#Point ::= point1d | point2d
def point?(o)
  point1d?(o) or o.point2d?
end

#PrimShape ::= Range1d | Range2d
def prim_shape?(o)
  range1d?(o) or o.range2d?
end

#UnionShape ::= Union1d | Union2d
def union_shape?(o)
  o.union1d? or o.union2d?
end

#CompShape? ::= UnionShape
def comp_shape?(o)
  union_shape?(o)
end

#Shape? ::= PrimShape | CompShape
def shape?(o)
  prim_shape?(o) or comp_shape?(o)
end

#Graphobj ::= Point | Shape
def graph_obj?(o)
  point?(o) or shape?(o)
end

##
# Functions on GraphicObjects
##

#shape_include? ::= (shape, point) :: Shape x Point ->? bool :: same dimensional objects
def shape_include?(shape, point)
  if    shape1d?(shape) and point1d?(point) then  shape_include_1d?(shape, point)
  elsif shape2d?(shape) and point.point2d?  then  shape_include_2d?(shape, point)
  else  check_pre(false)
  end
end

def shape_include_1d?(shape, point)
  check_pre(point1d?(point))
  if    shape.union1d?  then    shape_include_1d?(shape.left, point) or
                                shape_include_1d?(shape.right, point)
  elsif range1d?(shape)  then   point.in?(shape)
  else  check_pre(false)
  end
end

def shape_include_2d?(shape, point)
  check_pre(point.point2d?)
  if    shape.union2d?  then  shape_include_2d?(shape.left, point) or
                              shape_include_2d?(shape.right, point)
  elsif shape.range2d?  then  shape_include_1d?(shape.x_range, point.x) and
                              shape_include_1d?(shape.y_range, point.y)
  else  check_pre(false)
  end
end

#translate ::= (shape, point) :: Shape x Point ->? Shape :: same dimension of given Objects
def translate(shape, point)
  if    shape1d?(shape) and point1d?(point) then trans1d(shape, point)
  elsif shape2d?(shape) and point.point2d?  then trans2d(shape, point)
  else  check_pre(false)
  end
end

def trans1d(shape, point)
  check_pre(point1d?(point))
  if    shape.union1d?  then  Union1d[trans1d(shape.left, point),
                              trans1d(shape.right, point)]
  elsif range1d?(shape) then  (trans0d(shape.first, point)..trans0d(shape.last, point))
  else  check_pre(false)
  end
end

def trans0d(point1, point2)
  check_pre((point1d?(point1) and point1d?(point2)))
  point1 + point2
end

def trans2d(shape, point)
  check_pre(point.point2d?)
  if    shape.union2d?   then   Union2d[trans2d(shape.left, point),
                                trans2d(shape.right, point)]
  elsif shape.range2d?   then   Range2d[trans1d(shape.x_range, point.x),
                                trans1d(shape.y_range, point.y)]
  else  check_pre(false)
  end
end

#bounds ::= (shape) :: Shape x-> (Range1d | Range2d)
def bounds(shape)
  if    shape.union1d?                    then  bounding_range1d(bounds(shape.left), bounds(shape.right))
  elsif shape.union2d?                    then  bounding_range2d(bounds(shape.left), bounds(shape.right))
  elsif range1d?(shape) or shape.range2d? then  shape  
  else  check_pre(false)
  end
end

def bounding_range1d(range1, range2)
  check_pre((range1d?(range1) and range1d?(range2)))
  (range1.first <= range2.first ? range1.first : range2.first)..(range1.last >= range2.last ? range1.last : range2.last)
end

def bounding_range2d(range1, range2)
  check_pre((range1.range2d? and range2.range2d?))
  Range2d[bounding_range1d(range1.x_range, range2.x_range), bounding_range1d(range1.y_range, range2.y_range)]
end
###
#Equalities
###
#equal_by_dim? ::= GraphObj x GraphObj -> bool
def equal_by_dim?(graph_obj1, graph_obj2)
  check_pre((graph_obj?(graph_obj1) and graph_obj?(graph_obj2)))
  (one_dim?(graph_obj1) and one_dim?(graph_obj1)) or (two_dim?(graph_obj1) and two_dim?(graph_obj2))
end

def one_dim?(graph_obj)
  check_pre(graph_obj?(graph_obj))
  point1d?(graph_obj) or shape1d?(graph_obj)
end

def two_dim?(graph_obj)
  check_pre(graph_obj?(graph_obj))
  graph_obj.point2d? or shape2d?(graph_obj)
end

#equal_by_tree ::= GraphObj x GraphObj -> bool
def equal_by_tree?(graph_obj1, graph_obj2)
  check_pre((graph_obj?(graph_obj1) and graph_obj?(graph_obj2)))
  if    (not equal_by_dim?(graph_obj1, graph_obj2))     then  false
  elsif graph_obj1.union1d? and graph_obj2.union1d?     then  equal_by_tree?(graph_obj1.left, graph_obj2.left) and 
                                                              equal_by_tree?(graph_obj1.right, graph_obj2.right)
  elsif (range1d?(graph_obj1) and range1d?(graph_obj2)) or
        (point1d?(graph_obj1) and point1d?(graph_obj2)) then  (graph_obj1 == graph_obj2)
  elsif graph_obj1.union2d? and graph_obj2.union2d?     then  equal_by_tree?(graph_obj1.left, graph_obj2.left) and 
                                                              equal_by_tree?(graph_obj1.right, graph_obj2.right)
  elsif (graph_obj1.range2d? and graph_obj2.range2d?)   then  (graph_obj1.x_range == graph_obj2.x_range) and
                                                              (graph_obj1.y_range == graph_obj2.y_range)
  elsif (graph_obj1.point2d? and graph_obj2.point2d?)   then  (graph_obj1.x == graph_obj2.x) and (graph_obj1.y == graph_obj2.y)
  else  false
  end
end