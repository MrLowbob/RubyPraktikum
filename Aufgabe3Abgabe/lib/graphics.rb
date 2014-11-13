
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
  check_pre((graph_obj?(shape) and graph_obj?(point) and equal_by_dim?(shape, point)))
  if    shape.union1d? or shape.union2d? then shape_include?(shape.left, point) or
                                              shape_include?(shape.right, point)
  elsif range1d?(shape) then                  point.in?(shape)
  elsif shape.range2d?  then                  shape_include?(shape.x_range, point.x) and
                                              shape_include?(shape.y_range, point.y)
  else  check_pre(false)
  end
end

#translate ::= (shape, point) :: Shape x Point ->? Shape :: same dimension of given Objects
def translate(graph_obj, point)
  check_pre((graph_obj?(graph_obj) and point?(point) and equal_by_dim?(graph_obj, point)))
  if    graph_obj.union1d? or graph_obj.union2d?  then  graph_obj.class[translate(graph_obj.left, point),
                                                        translate(graph_obj.right, point)]
  elsif range1d?(graph_obj)                       then  (translate(graph_obj.first, point)..translate(graph_obj.last, point))
  elsif graph_obj.range2d?                        then  Range2d[translate(graph_obj.x_range, point.x),
                                                        translate(graph_obj.y_range, point.y)]
  elsif point1d?(graph_obj)                       then  graph_obj + point
  else  check_pre(false)
  end
end

#bounds ::= (shape) :: Shape x-> (Range1d | Range2d)
def bounds(shape)
  check_pre(shape?(shape))
  if    union_shape?(shape)                   then  bounding_range(bounds(shape.left), bounds(shape.right))
  elsif range1d?(shape) or shape.range2d?     then  shape  
  else  check_pre(false)
  end
end

def bounding_range(range1, range2)
  if range1d?(range1) and range1d?(range2)  then  (range1.first <= range2.first ? range1.first : range2.first)..
                                                  (range1.last >= range2.last ? range1.last : range2.last)
  elsif range1.range2d? and range2.range2d? then  Range2d[bounding_range(range1.x_range, range2.x_range), 
                                                          bounding_range(range1.y_range, range2.y_range)]
  end
end
###
#Equalities
###

CLASS_TO_DIM = {
  Fixnum  => 1,
  Range   => 1,
  Union1d => 1,
  Point2d => 2,
  Range2d => 2,
  Union2d => 2
  }
def get_dimension(o)  CLASS_TO_DIM[o.class] end
#equal_by_dim? ::= GraphObj x GraphObj -> bool
def equal_by_dim?(graph_obj1, graph_obj2)
  check_pre((graph_obj?(graph_obj1) and graph_obj?(graph_obj2)))
  get_dimension(graph_obj1) == get_dimension(graph_obj2)
end

#equal_by_tree? ::= GraphObj x GraphObj -> bool
def equal_by_tree?(graph_obj1, graph_obj2) # diese Gleichheit entspricht: obj1 == obj2
  check_pre((graph_obj?(graph_obj1) and graph_obj?(graph_obj2)))
  if    (not equal_by_dim?(graph_obj1, graph_obj2))        then  false
  elsif graph_obj1.union1d?     or graph_obj1.union2d?     then  equal_by_type?(graph_obj1, graph_obj2) and  equal_by_tree?(graph_obj1.left, graph_obj2.left) and 
                                                                 equal_by_tree?(graph_obj1.right, graph_obj2.right)
  elsif range1d?(graph_obj1)    or point1d?(graph_obj1)    then  (graph_obj1 == graph_obj2)
  elsif graph_obj1.range2d?     then  graph_obj2.range2d?  and (graph_obj1.x_range == graph_obj2.x_range) and
                                                               (graph_obj1.y_range == graph_obj2.y_range)
  elsif graph_obj1.point2d?     then  graph_obj2.point2d?  and (graph_obj1.x == graph_obj2.x) and 
                                                               (graph_obj1.y == graph_obj2.y)
  else  false
  end
end

def equal_by_type?(obj1, obj2)
  obj1.class == obj2.class
end 

#equal_by_trans? ::= GraphObj x GraphObj -> bool
def equal_by_trans?(graph_obj1, graph_obj2)
  check_pre((graph_obj?(graph_obj1) and graph_obj?(graph_obj2)))
  bounds_obj1 = bounds(graph_obj1)
  bounds_obj2 = bounds(graph_obj2)
  if    (not equal_by_dim?(graph_obj1, graph_obj2) or (not (bounds_obj1.size == bounds_obj2.size))) then false
  elsif equal_by_tree?(translate(graph_obj1, shift(bounds_obj1, bounds_obj2)), graph_obj2)          then true
  else  false
  end
end

# die Berechnung in die nächst tiefere Abstraktionsebene, der übersichtlichkeit halber
def shift(bounds_obj1, bounds_obj2)
  check_pre((prim_shape?(bounds_obj1) and prim_shape?(bounds_obj2)))
  if      not equal_by_dim?(bounds_obj1, bounds_obj2) then  false
  elsif   get_dimension(bounds_obj1) == 1             then  -(bounds_obj1.first - bounds_obj2.first)
  elsif   get_dimension(bounds_obj2) == 2             then  Point2d[-(bounds_obj1.x_range.first - bounds_obj2.x_range.first),
                                                      -(bounds_obj1.y_range.first - bounds_obj2.y_range.first)]
  else  check_pre(false)
  end
end

