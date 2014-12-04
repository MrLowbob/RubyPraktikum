# Translate == Shift


$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'
##
# 1-Dimensional graphics
##


#point1d ::= int
def_class(:Point1d, [:x]) {
  def invariant?
    x.int?
  end
  
  def shape_include?(point)
    check_pre(point.point1d?)
    point == self
  end
  
  def translate(point)
    Point1d[self.x + point.x]
  end
  
  def bounds
    self
  end
  
  def equal_by_dim?(obj1d)
    dim(self) == dim(obj1d)
  end 
  
  def equal_by_tree?(obj)
    self == obj
  end
  
  def equal_by_trans?(obj)
     if     not self.equal_by_dim?(obj) then false
     elsif  not obj.point1d? then false
     else   true
     end
  end 

  def shift(obj)
   check_pre((self.equal_by_dim?(obj) and obj.point1d?))
   Point1d[(self.x - obj.x)]
  end
}

#Range1d ::= range[first, last] :: Point1d x Point1d
def_class(:Range1d, [:first, :last]) {
  def invariant?
    first.point1d? and last.point1d?
  end
  
  def shape_include?(point)
    check_pre(point.point1d?)
    (first.x..last.x).include?(point.x)
  end
  
  def translate(point)
    check_pre(point.point1d?)
    Range1d[self.first.translate(point), self.last.translate(point)]
  end
  
  def bounds
    self
  end
  
  def equal_by_dim?(obj1d)
    dim(self) == dim(obj1d)
  end 
  
  def equal_by_tree?(obj)
    if not obj.range1d? then false
    else obj.first.equal_by_tree?(self.first) and obj.last.equal_by_tree?(self.last)
    end
  end
  
  def equal_by_trans?(obj)
     if       not self.equal_by_dim?(obj) then false
     elsif    not obj.range1d?            then false
     else     self.equal_by_tree?(obj.translate(self.shift(obj)))
     end
  end
  
  def shift(obj)
   check_pre((self.equal_by_dim?(obj) and obj.range1d?))
   P1D[self.first.x - obj.first.x]
  end
}

#Union1d ::= Union1d[left, right] :: shape1d x shape1d
def_class(:Union1d, [:left, :right]) {
  def invariant?
    shape1d?(left) and shape1d?(right)
  end
  
  def shape_include?(point)
    check_pre(point.point1d?)
    left.shape_include?(point) or right.shape_include?(point)
  end
  
  def translate(point)
    check_pre(point.point1d?)
    Union1d[left.translate(point), right.translate(point)]
  end
  
  def bounds
    if left.range1d? and right.range1d?
      Range1d[((left.first.x <= right.first.x) ? left.first : right.first),((left.last.x >= right.last.x) ? left.last : right.last)]
    elsif left.union1d? or right.union1d? then Union1d[left.bounds, right.bounds].bounds
    else check_pre(false)
    end
  end
  
  def equal_by_dim?(obj1d)
    dim(self) == dim(obj1d)
  end 
  
  def equal_by_tree?(obj)
    if not obj.union1d? then false
    else obj.left.equal_by_tree?(self.left) and obj.right.equal_by_tree?(self.right)
    end 
  end
  
  def equal_by_trans?(obj)
     if       not self.equal_by_dim?(obj) then false
     elsif    not obj.union1d?            then false
     else     self.equal_by_tree?(obj.translate((self.bounds).shift(obj.bounds)))
     end
  end
  
  def shift(obj)
   check_pre((self.equal_by_dim?(obj)))
   P1D[(self.first.shift(obj.first)).x]
  end
}

#Shape1d ::= Range1d | Union1d
def shape1d?(o)
  o.union1d? or o.range1d?
end

##
# 2-Dimensional graphics
##

#Point2d ::= Point1d x Point1d
def_class(:Point2d,[:x, :y]) {
  def invariant? 
    x.point1d? and y.point1d?
  end
  
  def shape_include?(point)
    check_pre(point.point2d?)
    self == point
  end
  
  def translate(point)
    check_pre(point.point2d?)
    Point2d[x.translate(point.x), y.translate(point.y)]
  end
  
  def bounds
    self
  end
  
  def equal_by_dim?(obj1d)
    dim(self) == dim(obj1d)
  end 
  
  def equal_by_tree?(obj)
    if not obj.point2d? then false
    else self.x == obj.x and self.y == obj.y
    end
  end
  
   def equal_by_trans?(obj)
     if       not self.equal_by_dim?(obj) then false
     elsif    not obj.range1d?            then false
     else     self.equal_by_tree?(obj.translate((self.bounds).shift(obj.bounds)))
     end
   end
  
  def shift(point)
   check_pre((self.equal_by_dim?(point) and point.point2d?))
   P2D[P1D[self.x.x - point.x.x],P1D[self.y.x - point.y.x]]
  end
}
#Range2d ::= Range2d[x_range, y_range] :: Range1d x Range1d
def_class(:Range2d,[:x_range, :y_range]){
  def invariant?
    x_range.range1d? and y_range.range1d?
  end
  
  def shape_include?(point)
    check_pre(point.point2d?)
    self.x_range.shape_include?(point.x) and
      self.y_range.shape_include?(point.y)  
  end
  
  def translate(point)
    check_pre(point.point2d?)
    Range2d[x_range.translate(point.x), y_range.translate(point.y)]
  end
  
  def bounds
    self
  end
  
  def equal_by_dim?(obj1d)
    dim(self) == dim(obj1d)
  end 
  
  def equal_by_tree?(obj)
    if not obj.range2d? then false
    else self.x_range == obj.x_range and self.y_range == obj.y_range
    end
  end
  
  def equal_by_trans?(obj)
     if       not self.equal_by_dim?(obj) then false
     elsif    not obj.range2d?            then false
     else     self.equal_by_tree?(obj.translate((self.bounds).shift(obj.bounds)))
     end
  end
  
  def shift(point)
   check_pre((self.equal_by_dim?(point)))
   Point2d[self.x_range.shift(point.x_range), self.y_range.shift(point.y_range)]
  end
}

#Union2d ::= Union2d[left, right] :: Shape2d x Shape2d
def_class(:Union2d,[:left, :right]){
  def invariant?
    shape2d?(left) and shape2d?(right)
  end
  
  def shape_include?(point)
    check_pre(point.point2d?)
    left.shape_include?(point) or 
      right.shape_include?(point)
  end
  
  def translate(point)
    check_pre(point.point2d?)
    Union2d[left.translate(point), right.translate(point)]
  end
  
  def bounds
    if left.range2d? and right.range2d?
      Range2d[Union1d[left.x_range, right.x_range].bounds, Union1d[left.y_range, right.y_range].bounds]
    elsif left.union2d? or right.union2d? then Union2d[left.bounds, right.bounds].bounds
    end
  end
  
  def equal_by_dim?(obj1d)
    dim(self) == dim(obj1d)
  end 
  
  def equal_by_tree?(obj)
    if not obj.union2d? then false
    else self.left == obj.left and self.right == obj.right
    end
  end
  
  def equal_by_trans?(obj)
     if       not self.equal_by_dim?(obj) then false
     elsif    not obj.union2d?            then false
     else     self.equal_by_tree?(obj.translate((self.bounds).shift(obj.bounds)))
     end
  end
  
  def shift(point)
   check_pre((self.equal_by_dim?(point)))
   Point2d[self.bounds.x_range.shift(point.bounds.x_range), self.bounds.y_range.shift(point.bounds.y_range)]
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

# shape.class[translate....]
#bounds ::= (shape) :: Shape x-> (Range1d | Range2d)

###
#Equalities
###

CLASS_TO_DIM = {Point1d => 1,
  Range1d => 1,
  Union1d => 1,
  Point2d => 2,
  Range2d => 2,
  Union2d => 2
}

def dim(o) CLASS_TO_DIM[o.class] end 

#equal_by_dim? ::= GraphObj x GraphObj -> bool

#equal_by_tree? ::= GraphObj x GraphObj -> bool

# equal_by_tree(translate(o1,norm_shift(bounds(o1,o1),translate(o1,norm_shift(bounds(o1),o1)))
# equal_by_tree(translate(o1,shift(bounds(o1),bounds(o2)),o2))


def equal_by_trans?(graph_obj1, graph_obj2)
  check_pre((graph_obj?(graph_obj1) and graph_obj?(graph_obj2)))
  if not equal_by_dim?(graph_obj1, graph_obj2) then false
  else equal_by_tree?(translate(graph_obj1, shift(bounds(graph_obj1), bounds(graph_obj2))), graph_obj2)
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
##  elsif graph_obj1.union2d?                             then  graph_obj2.union2d? and equal_by_tree?(graph_obj1.left, graph_obj2.left) and 
##                                                              equal_by_tree?(graph_obj1.right, graph_obj2.right)
##  elsif (graph_obj1.range2d? then graph_obj2.range2d? and (graph_obj1.x_range == graph_obj2.x_range) and
###                                                         (graph_obj1.y_range == graph_obj2.y_range)
##  elsif (graph_obj1.point2d? then graph_obj2.point2d? and (graph_obj1.x == graph_obj2.x) and (graph_obj1.y == graph_obj2.y)
##  elsif (range1d?(graph_obj1)then range1d?(graph_obj2)) then true
##  elsif (point1d?(graph_obj1)then point1d?(graph_obj2)) then  true                                          
### else false
##  end
#end

# shape_include macht bei punkt kein sinn, weil n punkt keine menge ist., bounds und equal by trans ebenso
# dim direkt in die klassen