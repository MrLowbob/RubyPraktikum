
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
  check_pre((equal_by_dim?(shape, point) and shape?(shape) and point?(point)))
  if      range1d?(shape)  then shape.include?(point)
  elsif   shape.range2d?   then shape_include?(shape.x_range, point.x) or 
                                shape_include?(shape.y_range, point.y)
  elsif   union_shape?(shape)  then shape_include?(shape.left, point) or
                                shape_include?(shape.right, point)
  else    check_pre(false)
  end
end
#translate ::= (shape, point) :: Shape x Point ->? Shape :: same dimension of given Objects
#union1d und -2d zusammenführen.
# shape.class[translate....]

def translate(shape, point)
  check_pre((equal_by_dim?(shape, point) and graph_obj?(shape) and graph_obj?(point)))
  if      range1d?(shape) then (shape.first + point)..(shape.last + point)
  elsif   shape.union1d?  then Union1d[translate(shape.left, point),
                                translate(shape.right, point)]
  elsif   shape.range2d?  then Range2d[translate(shape.x_range, point.x),
                                translate(shape.y_range, point.y)]     
  elsif   shape.union2d?  then Union2d[translate(shape.left, point),
                                translate(shape.right, point)]
  else    check_pre(false)
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


CLASS_TO_DIM = {Integer => 1,Range => 1,Range2d => 2}

def dim(o)  CLASS_TO_DIM[o.class] end 


#equal_by_dim? ::= GraphObj x GraphObj -> bool
def equal_by_dim?(graph_obj1, graph_obj2)
  check_pre((graph_obj?(graph_obj1) and graph_obj?(graph_obj2)))
   ((point1d?(graph_obj1) or shape1d?(graph_obj1)) and (point1d?(graph_obj2) or shape1d?(graph_obj2))) or
   ((graph_obj1.point2d? or shape2d?(graph_obj1))  and (graph_obj2.point2d? or shape2d?(graph_obj2)))
end

#equal_by_tree? ::= GraphObj x GraphObj -> bool
def equal_by_tree?(graph_obj1, graph_obj2)
  check_pre((graph_obj?(graph_obj1) and graph_obj?(graph_obj2)))
  graph_obj1 == graph_obj2
end 

# equal_by_tree(translate(o1,norm_shift(bounds(o1,o1),translate(o1,norm_shift(bounds(o1),o1)))
# equal_by_tree(translate(o1,shift(bounds(o1),bounds(o2)),o2))


def equal_by_trans?(graph_obj1, graph_obj2)
  check_pre((graph_obj?(graph_obj1) and graph_obj?(graph_obj2)))
  if not equal_by_dim?(graph_obj1, graph_obj2) then false
  else equal_by_tree?(translate(graph_obj1, shift(bounds(graph_obj1), bounds(graph_obj2))), graph_obj2)
  end
end

def shift(obj1, obj2)
  check_pre((equal_by_dim?(obj1,obj2) and graph_obj?(obj1) and graph_obj?(obj2)))
  if      shape1d?(obj1) then obj2.first - obj1.first
  elsif   shape2d?(obj1) then Point2d[obj2.x_range.first - obj1.x_range.first,
                                      obj2.y_range.first - obj1.y_range.first]
  elsif   point?(obj1) and point?(obj2) then true
  else    check_pre((false))
  end 
end


#equal_by_trans? ::= OraphObj x GraphObj -> bool
#def equal_by_trans?(graph_obj1, graph_obj2)
#  check_pre((equal_by_dim?(graph_obj1,graph_obj2) and graph_obj?(graph_obj1) and graph_obj?(graph_obj2)))
#  bounds_obj1 = bounds(graph_obj1)
#  bounds_obj2 = bounds(graph_obj2)
#  if    (not (bounds_obj1.size == bounds_obj2.size)) #or (not equal_by_dim?(graph_obj1, graph_obj2))
#                false
#  elsif         shape1d?(graph_obj1) and shape1d?(graph_obj2) 
#                translate(graph_obj1, -(bounds_obj1.first - bounds_obj2.first)) == graph_obj2
#                #equal_by_tree?(translate(graph_obj1, -(bounds_obj1.first - bounds_obj2.first)), graph_obj2)
#  elsif         shape2d?(graph_obj1) and shape2d?(graph_obj2)
#                translate(graph_obj1, Point2d[-(bounds_obj1.x_range.first - bounds_obj2.x_range.first),
#                -(bounds_obj1.y_range.first - bounds_obj2.y_range.first)]) == graph_obj2
#                #equal_by_tree?(translate(graph_obj1, Point2d[-(bounds_obj1.x_range.first - bounds_obj2.x_range.first),   
#                #-(bounds(graph_obj1).y_range.first - bounds(graph_obj2).y_range.first)]), graph_obj2)
#  else          false
#  end
#end

#def to_array(obj)
#  if point1d?(obj) then  obj.to_a
#  elsif range1d?(obj) then  obj.to_a
#  elsif obj.union1d?  then  (to_array(obj.left) | to_array(obj.right))
#  end
#end
#
#print to_array(1..3)
#puts
#print to_array(Union1d[1..3,Union1d[8..10,4..6]])

#equal_by_tree? ::= GraphObj x GraphObj -> bool // das hier ist die rekursive idee
#def equal_by_tree?(graph_obj1, graph_obj2)
#  check_pre((graph_obj?(graph_obj1) and graph_obj?(graph_obj2)))
##  if    (not equal_by_dim?(graph_obj1, graph_obj2))     then  false
##  elsif graph_obj1.union1d?                             then  graph_obj2.union1d? and  equal_by_tree?(graph_obj1.left, graph_obj2.left) and 
##                                                              equal_by_tree?(graph_obj1.right, graph_obj2.right)
##  elsif graph_obj1.union2d? and graph_obj2.union2d?     then  equal_by_tree?(graph_obj1.left, graph_obj2.left) and 
##                                                              equal_by_tree?(graph_obj1.right, graph_obj2.right)
##  elsif (graph_obj1.range2d? and graph_obj2.range2d?)   or 
##        (graph_obj1.point2d? and graph_obj2.point2d?)   or
##        (range1d?(graph_obj1) and range1d?(graph_obj2)) or
##        (point1d?(graph_obj1) and point1d?(graph_obj2)) then  true                                          
###                                                             (graph_obj1.x_range == graph_obj2.x_range) and
###                                                             (graph_obj1.y_range == graph_obj2.y_range)
### elsif (graph_obj1.point2d? and graph_obj2.point2d?)   then  (graph_obj1.x == graph_obj2.x) and (graph_obj1.y == graph_obj2.y)
##  else  false
##  end
#end
