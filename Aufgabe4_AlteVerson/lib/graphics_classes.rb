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
  
  def graph_obj?()    true  end
  def point?()        true  end
  
  def translate(point)
    Point1d[self.x + point.x]
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
  
  def graph_obj?()    true  end
  def shape?()        true  end
  def shape1d?()      true  end
  def prim_shape?()   true  end
  
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
    left.shape1d? and right.shape1d?
  end
  
  def graph_obj?()    true  end
  def shape?()        true  end
  def shape1d?()      true  end
  def comp_shape?()   true  end
  def union_shape?()  true  end
  
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



##
# 2-Dimensional graphics
##

#Point2d ::= Point1d x Point1d
def_class(:Point2d,[:x, :y]) {
  def invariant? 
    x.point1d? and y.point1d?
  end
  
  def graph_obj?()    true  end
  def point?()        true  end
  
  def translate(point)
    check_pre(point.point2d?)
    Point2d[x.translate(point.x), y.translate(point.y)]
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
  
  def graph_obj?()    true  end
  def shape?()        true  end
  def shape2d?()      true  end
  def prim_shape?()   true  end
  
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
    left.shape2d? and right.shape2d?
  end
  
  def graph_obj?()    true  end
  def shape?()        true  end
  def shape2d?()      true  end
  def comp_shape?()   true  end
  def union_shape?()  true  end
  
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



CLASS_TO_DIM = {Point1d => 1,
  Range1d => 1,
  Union1d => 1,
  Point2d => 2,
  Range2d => 2,
  Union2d => 2
}

def dim(o) CLASS_TO_DIM[o.class] end 


#Point ::= point1d | point2d
#Shape1d ::= Range1d | Union1d
#Shape2d ::= Range2d | Union2d
#PrimShape ::= Range1d | Range2d
#UnionShape ::= Union1d | Union2d
#CompShape? ::= UnionShape
#Shape? ::= PrimShape | CompShape
#Graphobj ::= Point | Shape
class Object
  def point?()        false end
  def shape1d?()      false end
  def shape2d?()      false end
  def shape?()        false end
  def prim_shape?()   false end
  def union_shape?()  false end
  def comp_shape?()   false end
  def graph_obj?()    false end
end