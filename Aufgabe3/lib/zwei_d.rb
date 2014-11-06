$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'

#Point2d ::= Point2d[x,y] :: Point1dxPoint1d
def_class(:Point2d, [:x, :y]) {
  def invariant?
    x.int? and y.int?
  end
}

#Range2d ::= Range2d[x_range,y_range] :: Range1dxRange1d)
def_class(:Range2d, [:point1, :point2]) {
  def invariant?
    point2d?(point1) and point2d?(point2)
  end
}

#Union2d::=Union2d[left,right]:: Shape2dx Shape2d
def_class(:Union2d, [:left, :right]) {
  def invariant?
    shape2d?(left) or range2d?(left)
    shape2d?(right) or range2d?(right)
  end
}

#Shape2d::= Range2d | Union2d
def_class(:Shape2d, [:var]) {
  def invariant?
    shape2d?(var)
  end
}

def point2d?(o)
  o.point1d?
end

def range2d?(o)
  o.range2d?
end

#Shape2d::= Range2d| Union2d
def shape2d?(o)
  o.range2d? or o.union2d?
end