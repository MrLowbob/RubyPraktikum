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

#Point #
class Point < GraphObject
  def initialize(*args)
    @attr = args
  end
  
  def attr
    @attr
  end
  
  def invariant?() self.map{|attr| attr.int?} end
  def point?() true end
  def to_s() "#{self.class.name} + #{attr.map{|attr| attr.to_s}}" end
  def equal_by_tree?(obj) self == obj end
  def equal_by_trans?(obj)
     self.equal_by_dim?(obj) and obj.point?
  end
end


#Point1d ::= Point1d(x) :: int
class Point1d < Point
  def point1d?() true end
  def ==(o) self.equal?(o) or (o.point1d? and (self.attr[0] == o.attr[0])) end
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


#Point2d ::= Point1d x Point1d
class Point2d < Point
  def dim() 2 end
  def point2d?() true end
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

