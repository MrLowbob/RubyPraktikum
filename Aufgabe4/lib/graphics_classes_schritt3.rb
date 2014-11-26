$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'
##
# 1-Dimensional graphics
##

#GraphObj # 
class GraphObject
  
  #GraphObj # graph_obj? := Any -> bool
  def graph_obj?() true end
  def self.[](*args); check_inv(self.new(*args)) end
  #dim ::= Int ::
  def dim() abstract end
   
  #equal_by_dim? ::= GraphObj x GraphObj -> bool
  def equal_by_dim?(obj) obj.graph_obj? and (self.dim == obj.dim) end
  #equal_by_trans? ::= OraphObj x GraphObj -> bool
  def equal_by_trans() abstract end
  #equal_by_tree? ::= GraphObj x GraphObj -> bool
  def equal_by_tree?() abstract end
  #equal_by_class?() ::= GraphObj x GraphObj -> bool
  def equal_by_class?(o) o.class == self.class end
  
  #bounds ::= (shape) :: Shape x-> (Range1d | Range2d)
  def bounds() abstract end
  #translate ::= Shape x Point -> Shape
  def translate() abstract end
  #translate ::= Shape x Shape -> Point
  def shift()     abstract end
  
  def ==(o) abstract end
  #to_s ::= Shape | Point -> String
  def to_s() abstract end
end

#Shape  #
class Shape < GraphObject
  def initialize(left,right) @left = left; @right = right end
  attr_reader :left, :right
  def shape?() true end
  def ==(o) self.equal?(o) or ((self.left == o.left) and (self.right == o.right)) end  #Range1d? und so fehlt, wie bauen wir das ein?
  def to_s() "#{self.class.name}[#{self.left.to_s},#{self.right.to_s}]" end
  
  def equal_by_trans?(obj)
     if       not self.equal_by_dim?(obj)             then false
     elsif    not self.equal_by_class?(obj)           then false
     else     self.equal_by_tree?(obj.translate((self.bounds).shift(obj.bounds)))
     end
  end
  
  def equal_by_tree?(obj)
#    if not self.equal_by_class?(obj) then false
    obj.left == self.left and obj.right == self.right
#    end
  end
end

#Point #
class Point < GraphObject
  def point?() true end
  def shape_include?(point); self == point end  #point.point1d? rausgenommen
  def bounds() self end
end

#point1d ::= int
class Point1d < Point
  def initialize(x)
    @x = x
  end
  
  def x() @x end
  def invariant?() x.int? end
  def point1d?() true end
  def ==(o) self.equal?(o) or (o.point1d? and (self.x == o.x)) end
  def to_s() "#{self.class.name}[#{self.x.to_s}]" end
  def dim() 1 end
  
  def equal_by_tree?(obj)
    self == obj
  end
  
  def equal_by_trans?(obj)
     if     not self.equal_by_dim?(obj) then false
     elsif  not obj.point1d? then false
     else   true
     end
  end 

  def translate(point)
    Point1d[self.x + point.x]
  end
  
  def shift(obj)
   check_pre((self.equal_by_dim?(obj) and obj.point1d?))
   Point1d[(self.x - obj.x)]
  end
end

#Range1d ::= range[first, last] :: Point1d x Point1d
class Range1d < Shape
  
  def dim() 1 end
  def range1d?() true end
  def invariant?() left.point1d? and right.point1d? end
  
  def shape_include?(point)
    check_pre(point.point1d?)
    (left.x..right.x).include?(point.x)
  end
  
  def translate(point)
    check_pre(point.point1d?)
    Range1d[left.translate(point), right.translate(point)]
  end
  
  def bounds() self end
  
  def shift(obj)
   check_pre((self.equal_by_dim?(obj) and obj.range1d?))
   P1D[self.left.x - obj.left.x]
  end
end

#Union1d ::= Union1d[left, right] :: shape1d x shape1d
class Union1d < Shape
  
  def dim() 1 end
  def union1d?() true end
  def invariant?() shape1d?(left) and shape1d?(right) end
  
  def shape_include?(point)
    check_pre(point.point1d?)
    left.shape_include?(point) or right.shape_include?(point)
  end
  
  def translate(point)
    check_pre(point.point1d?)
    Union1d[left.translate(point), right.translate(point)]
  end
  
  def bounds #man könnte mit type arbeiten hier, und range1d aus dem type herausholen?
    if left.range1d? and right.range1d?
      Range1d[((left.left.x <= right.left.x) ? left.left : right.left),((left.right.x >= right.right.x) ? left.right : right.right)]
    elsif left.union1d? or right.union1d? then Union1d[left.bounds, right.bounds].bounds
    else check_pre(false)
    end
  end
  
  def shift(obj)
   check_pre((self.equal_by_dim?(obj)))
   P1D[(self.bounds.left.shift(obj.bounds.left)).x]
  end
end

#Shape1d ::= Range1d | Union1d
def shape1d?(o)
  o.union1d? or o.range1d?
end

##
# 2-Dimensional graphics
##

#Point2d ::= Point1d x Point1d
class Point2d < Point
  def initialize(x,y)
    @x = x
    @y = y
  end
  
  def dim() 2 end
  def x() @x end
  def y() @y end
  def point2d?() true end
  def invariant?() x.point1d? and y.point1d? end
  def ==(o) self.equal?(o) or (o.point2d? and self.x == o.x and self.y == o.y) end
  def to_s() "#{self.class.name}[#{self.x},#{self.y}]" end
  
  def translate(point)
    check_pre(point.point2d?)
    Point2d[x.translate(point.x), y.translate(point.y)]
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
end

#Range2d ::= Range2d[x_range, y_range] :: Range1d x Range1d
class Range2d < Shape
  
  def dim() 2 end
  def range2d?() true end 
  def invariant?() left.range1d? and right.range1d? end
  
  def shape_include?(point)
    check_pre(point.point2d?)
      left.shape_include?(point.x) and
      right.shape_include?(point.y)  
  end
  
  def translate(point)
    check_pre(point.point2d?)
    Range2d[left.translate(point.x), right.translate(point.y)]
  end
  
  def bounds
    self
  end
  
  def shift(point)
   check_pre((self.equal_by_dim?(point)))
   Point2d[self.left.shift(point.left), self.right.shift(point.right)]
  end
end

#Union2d ::= Union2d[left, right] :: Shape2d x Shape2d
class Union2d < Shape
  
  def dim() 2 end
  def union2d?() true end
  def invariant?() shape2d?(left) and shape2d?(right) end
  
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
      Range2d[Union1d[left.left, right.left].bounds, Union1d[left.right, right.right].bounds]
    elsif left.union2d? or right.union2d? then Union2d[left.bounds, right.bounds].bounds
    end
  end
  
  def shift(point)
   check_pre((self.equal_by_dim?(point)))
   Point2d[self.bounds.left.shift(point.bounds.left), self.bounds.right.shift(point.bounds.right)]
  end
end

#Shape2d ::= Range2d | Union2d
def shape2d?(o)
  o.range2d? or o.union2d?
end


class Diff1d
  def initialze(left, right)
    @left = left
    @right = right
  end
  
  attr_reader :left,:right
  def diff1d?() true end
  def invariant?() left.equal_by_dim?(right) and shape1d?(left) and shape1d?(right) end
  def self.[](*args); check_inv(self.new(*args)) end
  
  def shape_include?(point)
    left.shape_include?(point) and not right.shape_include?(point)
  end
  
  def bounds
    left.bounds
  end
  
  def translate(point)
    left.translate(point) and right.translate(point)
  end
  
  def shift(shape)
    left.shift(shape) and right.shift(shape)
  end
  
  def equal_by_dim?(obj) left.equal_by_dim?(obj) end
  #Diff1d x Diff1d -> bool
  def equal_by_tree?(obj) left.equal_by_tree?(obj.left) and right.equal_by_tree?(obj.right) end #zwei Diff vergleichen
  
  #Diff1d x Diff1d -> bool
  def equal_by_trans?(obj)
     if       not self.equal_by_dim?(obj)   then false
     elsif    not self.equal_by_class?(obj) then false
     else     self.equal_by_tree?(obj.translate((self.bounds).shift(obj.bounds)))
     end
  end
end

class Diff2d
  def initialze(left, right)
    @left = left
    @right = right
  end
  
  attr_reader :left,:right
  def diff2d?() true end
  
  def shape_include?(point)
    left.shape_include?(point) and not right.shape_include?(point)
  end
  
  def bounds
    left.bounds
  end
  
  def translate(point)
    left.translate(point) and right.translate(point)
  end
  
  def shift(shape)
    left.shift(shape) and right.shift(shape)
  end
  
  def equal_by_dim?(obj) left.equal_by_dim?(obj) end
  #Diff2d x Diff2d -> bool
  def equal_by_tree?(obj) left.equal_by_tree?(obj.left) and right.equal_by_tree?(obj.right) end #zwei Diff vergleichen
  
  #Diff2d x Diff2d -> bool
  def equal_by_trans?(obj)
     if       not self.equal_by_dim?(obj) then false
     elsif    not self.equal_by_class?(obj) then false
     else     self.equal_by_tree?(obj.translate((self.bounds).shift(obj.bounds)))
     end
  end
  
  def equal_by_class?(obj) left.class == obj.left.class and right.class == obj.right.class end 
end

###
#Object
### 

class Object
  def graph_obj?() false end
  def point?() false end
  def shape?() false end
  
  def point1d?() false end
  def range1d?() false end
  def union1d?() false end
  def point2d?() false end
  def range2d?() false end
  def union2d?() false end
  
  def diff1d?() false end
  def diff2d?() false end
end











##
# Dimensionsunabhängig
##
#
#
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