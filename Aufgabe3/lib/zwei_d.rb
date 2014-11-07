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
    point1.point2d? and point2.point2d?
  end
}

#Union2d::=Union2d[left,right]:: Shape2dx Shape2d
def_class(:Union2d, [:left, :right]) {
  def invariant?
    left.shape2d?   or left.range2d?
    right.shape2d?  or right.range2d?
  end
}

#Shape2d::= Range2d | Union2d
def_class(:Shape2d, [:var]) {
  def invariant?
    var.range2d? or var.union2d?
  end
}

def shape2d?(var)
  var.range2d? or var.union2d?
end