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
  #shift ::= GraphObj x GraphObj -> Point
  def shift()     abstract end
  
  #== ::= Class x Class -> bool
  def ==(o) abstract end
  #to_s ::= Shape | Point -> String
  def to_s() abstract end
end

#Shape  #
class Shape < GraphObject
  def shape?() true end
end

#Point #
class Point < GraphObject
  def point?() true end
  def equal_by_tree?(obj) self == obj end
  def equal_by_trans?(obj)
     self.equal_by_dim?(obj) and obj.point?
  end
end

class UnionShape < Shape
  def union_shape?() true end
  def initialize(left,right) @left = left; @right = right end
  attr_reader :left, :right
  def ==(o) self.equal?(o) or ((self.left == o.left) and (self.right == o.right)) end
  def to_s() "#{self.class.name}[#{self.left.to_s},#{self.right.to_s}]" end
  
  def invariant?()
    left.shape? and right.shape?
    left.dim == self.dim and right.dim == self.dim
  end
  
  def shape_include?(point)
    check_pre(self.equal_by_dim?(point))
    left.shape_include?(point) or right.shape_include?(point)
  end
  
  def translate(point)
    check_pre(self.equal_by_dim?(point))
    self.class[left.translate(point), right.translate(point)]
  end
  
  def equal_by_tree?(obj)
    obj.left == self.left and obj.right == self.right
  end
  
  def equal_by_trans?(obj)
     if       not self.equal_by_dim?(obj)             then false
     elsif    not self.equal_by_class?(obj)           then false
     else     self.equal_by_tree?(obj.translate((self.bounds).shift(obj.bounds)))
     end
  end
end

#Point1d ::= Point1d(x) :: int
class Point1d < Point
  def initialize(x)
    @x = x
  end
  
  attr_reader :x
  def invariant?() x.int? end
  def point1d?() true end
  def ==(o) self.equal?(o) or (o.point1d? and (self.x == o.x)) end
  def to_s() "#{self.class.name}[#{self.x.to_s}]" end
  def dim() 1 end

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
  def initialize(first,last)
    @first = first
    @last = last
  end
  
  attr_reader :first, :last
  
  def dim() 1 end
  def range1d?()    true end
  def shape1d?()    true  end
  def prim_shape?() true  end
  def invariant?() first.point1d? and last.point1d? end
  
  def ==(o) self.equal?(o) or ((self.first == o.first) and (self.last == o.last)) end
  def to_s() "#{self.class.name}[#{self.first.to_s},#{self.last.to_s}]" end
  
  def equal_by_tree?(obj)
    obj.first == self.first and obj.last == self.last
  end
  
  def shape_include?(point)
    check_pre(point.point1d?)
    (first.x..last.x).include?(point.x)
  end
  
  def translate(point)
    check_pre(point.point1d?)
    Range1d[first.translate(point), last.translate(point)]
  end
  
  def bounds() self end
  
  def shift(obj)
   check_pre((self.equal_by_dim?(obj) and obj.range1d?))
   Point1d[self.first.x - obj.first.x]
  end
  
   def equal_by_trans?(obj)
     if       not self.equal_by_dim?(obj)             then false
     elsif    not self.equal_by_class?(obj)           then false
     else     self.equal_by_tree?(obj.translate((self.bounds).shift(obj.bounds)))
     end
  end
end

#Union1d ::= Union1d[left, right] :: shape1d x shape1d
class Union1d < UnionShape
  
  def dim() 1 end
  
  #Predicates
  def union1d?()      true  end
  def shape1d?()      true  end
  def comp_shape?()   true  end
  def union_shape?()  true  end
  
  def bounds #man könnte mit type arbeiten hier, und range1d aus dem type herausholen?
    if left.range1d? and right.range1d?
      Range1d[((left.first.x <= right.first.x) ? left.first : right.first),((left.last.x >= right.last.x) ? left.last : right.last)]
    elsif left.union1d? or right.union1d? then Union1d[left.bounds, right.bounds].bounds
    else check_pre(false)
    end
  end
  
  def shift(obj)
   check_pre((self.equal_by_dim?(obj)))
   Point1d[(self.bounds.first.shift(obj.bounds.first)).x]
  end
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
  attr_reader :x, :y
  def point2d?() true end
  def invariant?() x.point1d? and y.point1d? end
  def ==(o) self.equal?(o) or (o.point2d? and self.x == o.x and self.y == o.y) end
  def to_s() "#{self.class.name}[#{self.x},#{self.y}]" end
  
  def translate(point)
    check_pre(point.point2d?)
    Point2d[x.translate(point.x), y.translate(point.y)]
  end
  
  def shift(point)
   check_pre((self.equal_by_dim?(point) and point.point2d?))
   Point2d[Point1d[self.x.x - point.x.x],Point1d[self.y.x - point.y.x]]
  end
end

#Range2d ::= Range2d[x_range, y_range] :: Range1d x Range1d
class Range2d < Shape
  def initialize(x_range,y_range)
    @x_range = x_range
    @y_range = y_range
  end
  
  attr_reader :x_range,:y_range
  def dim() 2 end
  def range2d?()      true  end 
  def shape2d?()      true  end
  def prim_shape?()   true  end
  
  def invariant?() x_range.range1d? and y_range.range1d? end
  def bounds() self end
  def ==(o) self.equal?(o) or ((self.x_range == o.x_range) and (self.y_range == o.y_range)) end  #Range1d? und so fehlt, wie bauen wir das ein?
  def to_s() "#{self.class.name}[#{self.x_range.to_s},#{self.y_range.to_s}]" end
  
  def equal_by_tree?(obj)
    obj.x_range == self.x_range and obj.y_range == self.y_range
  end
  
  def shape_include?(point)
    check_pre(point.point2d?)
      x_range.shape_include?(point.x) and
      y_range.shape_include?(point.y)  
  end
  
  def translate(point)
    check_pre(point.point2d?)
    Range2d[x_range.translate(point.x), y_range.translate(point.y)]
  end
  
  def shift(range)
   check_pre((self.equal_by_dim?(range)))
   Point2d[self.x_range.shift(range.x_range), self.y_range.shift(range.y_range)]
  end
  
   def equal_by_trans?(obj)
     if       not self.equal_by_dim?(obj)             then false
     elsif    not self.equal_by_class?(obj)           then false
     else     self.equal_by_tree?(obj.translate((self.bounds).shift(obj.bounds)))
     end
  end
  
end

#Union2d ::= Union2d[left, right] :: Shape2d x Shape2d
class Union2d < UnionShape
  
  def dim() 2 end
  
  #Predicates
  def union2d?()      true  end
  def shape2d?()      true  end
  def comp_shape?()   true  end
  def union_shape?()  true  end
  
  def bounds
    if left.range2d? and right.range2d?
      Range2d[Union1d[left.x_range, right.x_range].bounds, Union1d[left.y_range, right.y_range].bounds]
    elsif left.union2d? or right.union2d? then Union2d[left.bounds, right.bounds].bounds
    end
  end
  
  def shift(point)
   check_pre((self.equal_by_dim?(point)))
   Point2d[self.bounds.x_range.shift(point.bounds.x_range), self.bounds.y_range.shift(point.bounds.y_range)]
  end
end

###
#Difference classes
###

#Diff1d ::= (left, right) :::: Shape1d x Shape1d -> Shape1d
class Diff1d < Shape
  def initialze(left, right)
    @left = left
    @right = right
  end
  
  attr_reader :left,:right
  def diff1d?()       true  end
  def shape2d?()      true  end
  def comp_shape?()   true  end
  
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

#Diff2d ::= (left, right) :::: Shape2d x Shape2d -> Shape2d
class Diff2d < Shape
  def initialze(left, right)
    @left = left
    @right = right
  end
  
  attr_reader :left,:right
  def diff2d?()       true  end
  def shape2d?()      true  end
  def comp_shape?()   true  end
  
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
  def graph_obj?()    false end
  def point?()        false end
  def shape?()        false end
  def shape1d?()      false end
  def shape2d?()      false end
  def prim_shape?()   false end
  def union_shape?()  false end
  def comp_shape?()   false end
  
  def point1d?() false end
  def range1d?() false end
  def union1d?() false end
  def point2d?() false end
  def range2d?() false end
  def union2d?() false end
  
  def diff1d?() false end
  def diff2d?() false end
end
