$:.unshift File.join(File.dirname(__FILE__),'..','lib')
require 'eins_d'

$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'../..','ext_pr1/lib')
require 'ext_pr1_v4'

#Point2d ::= Point2d[x,y] :: Point1dxPoint1d
def_class(:Point2d, [:x, :y]) {
  def invariant?
    x.int? and y.int?
  end
}

#Range2d ::= Range2d[x_range,y_range] :: Range1d x Range1d)
def_class(:Range2d, [:range1, :range2]) {
  def invariant?
    range1d?(range1) and range1d?(range2)
  end
}

#Union2d::=Union2d[left,right]:: Shape2d x Shape2d
def_class(:Union2d, [:left, :right]) {
  def invariant?
    shape2d?(left)   or left.range2d?
    shape2d?(right)  or right.range2d?
  end
}

def shape2d?(var)
  var.range2d? or var.union2d?
end