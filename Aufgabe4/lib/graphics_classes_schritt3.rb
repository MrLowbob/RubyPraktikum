$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'
##
# 1-Dimensional graphics
##

###
#GraphObj # 
###
class GraphObject
  
  #Initialization
  def self.[](*args); check_inv(self.new(*args)) end
  def invariant?()    abstract end
  #dim ::= Int ::
  def dim()           abstract end
  
  #Predicates
  #GraphObj # graph_obj? := Any -> bool
  def graph_obj?()  true end
  #predicate ::= Any -> bool ::
  def predicate()   abstract end

  #Equals
  #equal_by_dim? ::= GraphObj x GraphObj -> bool
  def equal_by_dim?(obj)  obj.graph_obj? and (self.dim == obj.dim) end
  #equal_by_trans? ::= OraphObj x GraphObj -> bool
  def equal_by_trans()    abstract end
  #equal_by_tree? ::= GraphObj x GraphObj -> bool
  def equal_by_tree?()    abstract end
  #equal_by_class?() ::= GraphObj x GraphObj -> bool
  def equal_by_class?(o)  o.class == self.class end
  #== ::= Class x Class -> bool
  def ==(o) abstract end
  
  #Operations/Methods
  #bounds ::= (shape) :: Shape x-> (Range1d | Range2d)
  def bounds()    abstract end
  #translate ::= Shape x Point -> Shape
  def translate() abstract end
  #shift ::= GraphObj x GraphObj -> Point
  def shift()     abstract end
  
  #Conversions
  #to_s ::= Shape | Point -> String
  def to_s() abstract end
end

###
#Shape #
###
class Shape < GraphObject
  
  #Initialization
  def initialize(left, right)
    @left = left
    @right = right
  end
  def left()  @left  end
  def right() @right end
  
  #Predicates
  def shape?() true end
  
  #Operations/Methods
  def +(shape)
    check_pre((equal_by_dim?(shape) and shape.shape?))
    if    self.dim == 1 then  Union1d[self, shape]
    elsif self.dim == 2 then  Union2d[self, shape]
    else  check_pre false #Werkzeug für mehrfachvererbung
    end                   #noch nicht in Vorlesung behandelt.
  end
  
    def -(shape)
    check_pre((equal_by_dim?(shape) and shape.shape?))
    if    self.dim == 1 then  Diff1d[self, shape]
    elsif self.dim == 2 then  Diff2d[self, shape]
    else  check_pre false #Werkzeug für mehrfachvererbung
    end                   #noch nicht in Vorlesung behandelt.
  end
  
  #Equals
  def equal_by_tree?(obj)
    obj.left == self.left and obj.right == self.right
  end
  
  def equal_by_trans?(obj)
     if       not self.equal_by_dim?(obj)             then false
     elsif    not self.equal_by_class?(obj)           then false
     else     self.equal_by_tree?(obj.translate((self.bounds).shift(obj.bounds)))
     end
  end
  def ==(o)   self.equal?(o) or (o.predicate and (self.left == o.left) and (self.right == o.right)) end
  
  #Conversions
  def to_s()  "#{self.class.name}[#{self.left.to_s},#{self.right.to_s}]" end
end

###
#Point #
###
class Point < GraphObject
  #Predicates
  def point?() true end
  
  #Equals
  def equal_by_tree?(obj) self == obj end
  def equal_by_trans?(obj)
     self.equal_by_dim?(obj) and obj.point?
  end
end

###
#PrimShape
###
class PrimShape < Shape
  def prim_shape?() true  end
end
###
# CompShape
###
class CompShape < Shape
  #Init
  def invariant?()  left.shape? and right.shape? and
                    self.equal_by_dim?(left) and self.equal_by_dim?(right) end
                
  #Predicates
  def comp_shape?()  true  end
  
  #Operations/Methods 
  def translate(point)
    check_pre(self.equal_by_dim?(point))
    self.class[left.translate(point), right.translate(point)]
  end
  
  #Equals  
  def equal_by_trans?(obj)
    if       not self.equal_by_dim?(obj)   then false
    elsif    not self.equal_by_class?(obj) then false
    else     self.equal_by_tree?(obj.translate((self.bounds).shift(obj.bounds)))
    end
  end
end

###
#UnionShape
###
class UnionShape < CompShape
  #Predicates
  def union_shape?() true end

  #Operations/Methods
  def shape_include?(point)
    check_pre(self.equal_by_dim?(point))
    left.shape_include?(point) or right.shape_include?(point)
  end
end

###
#Point1d ::= Point1d(x) :: int
###
class Point1d < Point
  #Initialization
  def initialize(x) @x = x end
  attr_reader :x
  def dim()         1 end
  def invariant?()  x.int? end
  
  #Predicates
  def predicate() self.point1d? end
  def point1d?()  true end
  
  #Operations/Methods
  def translate(point)
    Point1d[self.x + point.x]
  end
  
  def shift(obj)
   check_pre((self.equal_by_dim?(obj) and obj.point1d?))
   Point1d[(self.x - obj.x)]
  end
  
  #Equals
  def ==(o)   self.equal?(o) or (o.point1d? and (self.x == o.x)) end
  
  #Conversions
  def to_s()  "#{self.class.name}[#{self.x.to_s}]" end
end

###
#Range1d ::= range[first, last] :: Point1d x Point1d
###
class Range1d < PrimShape
  #Initialization
  def first() @left end
  def last()  @right end
  def dim()   1 end
  def invariant?() first.point1d? and last.point1d? end
  
  #Predicates
  def predicate() self.range1d? end
  def range1d?()    true  end
  def shape1d?()    true  end
  
  #Operations/Methods
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
end

###
#Union1d ::= Union1d[left, right] :: shape1d x shape1d
###
class Union1d < UnionShape
  #Initialization
  def dim() 1 end
  
  #Predicates
  def union1d?()  true  end
  def shape1d?()  true  end
  def predicate() self.union1d? end
  
  #Operations/Methods
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

###
#Point2d ::= Point1d x Point1d
###
class Point2d < Point
  #Initialization
  def initialize(x,y)
    @x = x
    @y = y
  end
  def dim() 2 end
  attr_reader :x, :y
  def invariant?() x.point1d? and y.point1d? end
  
  #Predicates
  def point2d?() true end
  def predicate() self.point2d? end
  
  #Operations/Methods
  def translate(point)
    check_pre(point.point2d?)
    Point2d[x.translate(point.x), y.translate(point.y)]
  end
  
  def shift(point)
   check_pre((self.equal_by_dim?(point) and point.point2d?))
   Point2d[Point1d[self.x.x - point.x.x],Point1d[self.y.x - point.y.x]]
  end
  
  #Equals
  def ==(o) self.equal?(o) or (o.point2d? and self.x == o.x and self.y == o.y) end
  
  #Conversions
  def to_s() "#{self.class.name}[#{self.x},#{self.y}]" end
end

###
#Range2d ::= Range2d[x_range, y_range] :: Range1d x Range1d
###
class Range2d < PrimShape
  #Initializations
  def x_range() @left  end
  def y_range() @right end
  def dim() 2 end
  def invariant?() x_range.range1d? and y_range.range1d? end
  
  #Predicates
  def range2d?()      true  end 
  def shape2d?()      true  end
  def predicate() self.range2d? end
  
  #Operations/Methods
  def bounds() self end
  
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
end

###
#Union2d ::= Union2d[left, right] :: Shape2d x Shape2d
###
class Union2d < UnionShape
  #Initializations
  def dim() 2 end
  
  #Predicates
  def union2d?()      true  end
  def shape2d?()      true  end
  def predicate() self.union2d? end
  
  #Operations/Methods
  def bounds
    if left.range2d? and right.range2d?
      Range2d[Union1d[left.x_range, right.x_range].bounds, Union1d[left.y_range, right.y_range].bounds]
    elsif left.union2d? or right.union2d? then Union2d[left.bounds, right.bounds].bounds
    end
  end
  
  def shift(shape)
   check_pre((self.equal_by_dim?(shape)))
   Point2d[self.bounds.x_range.shift(shape.bounds.x_range), self.bounds.y_range.shift(shape.bounds.y_range)]
  end
end

###
#Difference classes
###

###
#DiffShape
###
class DiffShape < CompShape
  #Predicates
  def diff_shape?() true  end
  
  #Operations/Methods
  def bounds()  left.bounds end
  def shape_include?(point)
    left.shape_include?(point) and not right.shape_include?(point)
  end
  
  def shift(shape)
    check_pre equal_by_dim?(shape)
    left.shift(shape.left)
  end
end
###
#Diff1d ::= (left, right) :::: Shape1d x Shape1d -> Shape1d
###
class Diff1d < DiffShape
  #Initializations
  def dim() 1 end
  
  #Predicates
  def diff1d?()       true  end
  def shape1d?()      true  end
  def predicate()     self.diff1d? end
end

###
#Diff2d ::= (left, right) :::: Shape2d x Shape2d -> Shape2d
###
class Diff2d < DiffShape
  #Initializations
  def dim() 2 end

  #Predicates
  def diff2d?()   true  end
  def shape2d?()  true  end
  def predicate() self.diff2d? end
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
  def diff_shape?()   false end
  
  def point1d?() false end
  def range1d?() false end
  def union1d?() false end
  def point2d?() false end
  def range2d?() false end
  def union2d?() false end
  
  def diff1d?() false end
  def diff2d?() false end
end
